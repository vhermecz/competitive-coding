require 'io/console'

MEMORY_SIZE = 32768

class InstructionDesc
	attr_reader :mnemonic, :opcode, :param_num
	def initialize(mnemonic, opcode, param_num)
		@mnemonic = mnemonic
		@opcode = opcode
		@param_num = param_num
	end
end

module Instruction
	HALT = InstructionDesc.new(:halt, 0, 0)
	SET = InstructionDesc.new(:set, 1, 2)
	PUSH = InstructionDesc.new(:push, 2, 1)
	POP = InstructionDesc.new(:pop, 3, 1)
	EQ = InstructionDesc.new(:eq, 4, 3)
	GT = InstructionDesc.new(:gt, 5, 3)
	JMP = InstructionDesc.new(:jmp, 6, 1)
	JT = InstructionDesc.new(:jt, 7, 2)
	JF = InstructionDesc.new(:jf, 8, 2)
	ADD = InstructionDesc.new(:add, 9, 3)
	MULT = InstructionDesc.new(:mult, 10, 3)
	MOD = InstructionDesc.new(:mod, 11, 3)
	AND = InstructionDesc.new(:and, 12, 3)
	OR = InstructionDesc.new(:or, 13, 3)
	NOT = InstructionDesc.new(:not, 14, 2)
	RMEM = InstructionDesc.new(:rmem, 15, 2)
	WMEM = InstructionDesc.new(:wmem, 16, 2)
	CALL = InstructionDesc.new(:call, 17, 1)
	RET = InstructionDesc.new(:ret, 18, 0)
	OUT = InstructionDesc.new(:out, 19, 1)
	IN = InstructionDesc.new(:in, 20, 1)
	NOOP = InstructionDesc.new(:noop, 21, 0)
end

Instruction::FROM_OPCODE = Instruction.constants(false).map do |c|
	Instruction.const_get(c).then do |instruction_desc|
		[instruction_desc.opcode, instruction_desc]
	end
end.to_h

def hex(value)
	"0x" + value.to_s(16).rjust(4, "0")
end

class MagicVm
	attr_reader :memory, :registers, :stack
	attr_accessor :debug, :ip
	def initialize(snapshot)
		memory = snapshot.unpack("S<*")
		memory = memory[...MEMORY_SIZE]
		memory = memory + [0] * (MEMORY_SIZE - memory.length)
		@memory = memory
		@registers = [0] * 8  # TODO initial value?
		@stack = []  # TODO initial value?
		@ip = 0
		@clock = 0
		@debug = false
	end

	def self.from_snapshot_file(filename)
		self.new(File.read(filename))
	end

	def prim_read(ref)
		if ref <= 32767
			ref
		elsif ref <= 32775
			@registers[ref-32768]
		else
			raise RuntimeError.new("Invalid read address")
		end
	end

	def prim_write(ref, value)
		if ref <= 32767
			@memory[ref] = value
		elsif ref <= 32775
			@registers[ref-32768] = value
		else
			raise RuntimeError.new("Invalid write address")
		end
	end		

	def prim_halt
		raise RuntimeError.new("HALT")
	end

	def prim_out ch
		print(ch.chr)
	end

	def prim_in
		loop = true
		while loop
			value = STDIN.getch.ord
			case value
			when 3  # Ctrl+C
				prim_halt
			when 4  # Ctrl+D
				@debug = !@debug
				print "Turning debug #{@debug ? 'on' : 'off'}\n"
			when 8  # Ctrl+H
				puts "Help:"
				puts " Ctrl+C - terminate"
				puts " Ctrl+D - switch debugging"
				puts " Ctrl+H - this help"
				puts " Ctlr+R - repl"
			when 18  # Ctrl+R
				prim_debug_repl
			else
				loop = false
			end
		end
		print "read-input::#{value.ord}\n" if @debug
		value
	end

	def prim_debug_repl
		puts "REPL activated"
		loop = true
		while loop
			print "> "
			command = gets.downcase.split(" ")
			if command.first[0] == "."
				case command.first
				when ".exit"
					loop = false
				when ".dump"
					puts "clock=#{@clock} ip=#{hex(@ip)} #{@registers.each_with_index.map{|v,i|"r#{i}=#{hex(v)}"}.join ' '}"
				else
					puts "Unknown command"
					puts " .exit - Quits repl"
				end
			else
				if not Instruction.const_defined?(command.first.upcase.to_sym)
					puts "Unknonw instruction"
				else
					op = Instruction.const_get(command.first.upcase.to_sym)
					params = command[1..].each_with_index.map do |param, idx|
						value = prim_debug_ref_parse(param)
						puts "Param #{idx} is invalid (#{param}"
						value
					end
					if params.any?{|v|v.nil?} || params.length != op.param_num
						puts "Invalid or incorrect number of params"
					else
						@memory << op
						@memory += params
						ip = @ip
						@ip = MEMORY_SIZE
						process_next_instruction
						@ip = ip if @ip > MEMORY_SIZE  # reset if not altered ip
					end
				end
			end
		end
	end

	def prim_debug_ref_parse(serialized)
		type, value, rest = serialized.split("::")
		return nil if !rest.nil? || value.nil? || value.to_i.to_s != value
		value = value.to_i
		case type
		when "literal"
			value >= 0 && value <= 32767 ? value : nil
		when "ref"
			value >= 0 && value <= 7 ? value + 32768 : nil
		else
			nil
		end
	end		

	def prim_debug_ref_serialize(ref)
		if ref <= 32767
			"literal::#{ref}"
		elsif ref <= 32775
			"reg::#{ref-32768}"
		else
			"invalid"
		end
	end		

	def prim_debug
		opcode = @memory[@ip]
		desc = Instruction::FROM_OPCODE[opcode]
		params = desc.param_num.times.map{|p_idx|prim_debug_ref_serialize(@memory[@ip + 1 + p_idx])}
		print "<@#{@ip}:#{@registers} #{desc.mnemonic.upcase} #{params.join ' '}>\n"
	end

	def process_next_instruction
		prim_debug if @debug
		@clock += 1
		#print "clock at #{@clock}" if (@clock % 100) == 0
		op = @memory[@ip]
		a = @memory[@ip + 1]
		b = @memory[@ip + 2]
		c = @memory[@ip + 3]
		case op
		when Instruction::HALT.opcode
			prim_halt
		when Instruction::PUSH.opcode
			@stack << prim_read(a)
			@ip += 2
		when Instruction::POP.opcode
			raise RuntimeError.new("Pop on empty stack") if @stack.empty?
			prim_write(a, @stack.pop)
			@ip += 2
		when Instruction::EQ.opcode
			value = (prim_read(b) == prim_read(c)) ? 1 : 0
			prim_write(a, value)
			@ip += 4
		when Instruction::GT.opcode
			value = (prim_read(b) > prim_read(c)) ? 1 : 0
			prim_write(a, value)
			@ip += 4
		when Instruction::SET.opcode
			raise RuntimeError.new("Unspecified") if a <= 32767
			prim_write(a, prim_read(b))
			@ip += 3
		when Instruction::JMP.opcode
			@ip = prim_read(a)
		when Instruction::JT.opcode
			@ip = ((prim_read(a) != 0) ? prim_read(b) : (@ip + 3))
		when Instruction::JF.opcode
			@ip = ((prim_read(a) == 0) ? prim_read(b) : (@ip + 3))
		when Instruction::ADD.opcode
			value = (prim_read(b) + prim_read(c)) % 32768
			prim_write(a, value)
			@ip += 4
		when Instruction::MULT.opcode
			value = (prim_read(b) * prim_read(c)) % 32768
			prim_write(a, value)
			@ip += 4
		when Instruction::MOD.opcode
			value = (prim_read(b) % prim_read(c)) % 32768
			prim_write(a, value)
			@ip += 4
		when Instruction::AND.opcode
			value = (prim_read(b) & prim_read(c))
			prim_write(a, value)
			@ip += 4
		when Instruction::OR.opcode
			value = (prim_read(b) | prim_read(c))
			prim_write(a, value)
			@ip += 4
		when Instruction::NOT.opcode
			value = (prim_read(b) ^ 32767)  # FINE?
			prim_write(a, value)
			@ip += 3
		when Instruction::RMEM.opcode
			prim_write(a, @memory[prim_read(b)])
			@ip += 3
		when Instruction::WMEM.opcode
			@memory[prim_read(a)] = prim_read(b)
			@ip += 3
		when Instruction::CALL.opcode
			@ip += 2
			@stack << @ip
			@ip = prim_read(a)
		when Instruction::RET.opcode
			prim_halt if @stack.empty?
			@ip = @stack.pop
		when Instruction::OUT.opcode
			prim_out(prim_read(a))
			@ip += 2
		when Instruction::IN.opcode
			prim_write(a, prim_in)
			@ip += 2
		when Instruction::NOOP.opcode
			@ip += 1
		else
			raise RuntimeError.new("Unimplemented opcode #{op}")
		end
	end

	def execute
		process_next_instruction while true
	end
end

vm = MagicVm.from_snapshot_file("challenge.bin")
#vm.debug = true
p vm.registers
vm.execute
