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
	UNK = InstructionDesc.new(:unk, -1, 0)
end

Instruction::FROM_OPCODE = Instruction.constants(false).map do |c|
	Instruction.const_get(c).then do |instruction_desc|
		[instruction_desc.opcode, instruction_desc]
	end
end.to_h

def hex(value)
	"0x" + value.to_s(16).rjust(4, "0")
end

def parse_num(value)
	return value.to_i(16) if value.start_with? "0x"
	value.to_i
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
		@debug_coverage = nil
		@debug_memory_coverage = nil
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
			when 6  # Ctrl+F
				ip = @ip
				5.times do
					ip = prim_debug ip, print_regs=false
				end
			when 8  # Ctrl+H
				puts "Help:"
				puts " Ctrl+C - terminate"
				puts " Ctrl+D - switch debugging"
				puts " Ctrl+H - this help"
				puts " Ctlr+R - repl"
				puts " Ctrl+T - turn code coverage tracing on/off"
				puts " Ctrl+U - turn memory tracing on/off"
				puts " Ctrl+V - enter char code"
				puts " Ctrl+F - show the future 5 instructions"
			when 18  # Ctrl+R
				prim_debug_repl
			when 20  # Ctrl+T
				if @debug_coverage.nil?
					puts "Code Coverage Traing Turned on"
					@debug_coverage = []
				else
					puts "Code Coverage Traing Turned off. Data collected:"
					#puts @debug_coverage.uniq.sort.join ", "
					lines = @debug_coverage.group_by{|v|v}.sort.map{|k,v|[k,v.length]}
					lines << [0x20000, 0]
					last_end_addr = block_start = lines.first.first
					last_count = lines.first.last
					line_cnt = 0
					lines.each do |addr, count|
						line_cnt += 1
						instr = Instruction::FROM_OPCODE[@memory[addr]] || Instruction::UNK
						end_addr = addr + 1 + instr.param_num
						if addr != last_end_addr || count != last_count
							print "#{hex(block_start)}..#{hex(last_end_addr)}:#{last_count} (#{line_cnt} lines)\n"
							block_start = addr
							line_cnt = 0
						end
						last_end_addr = end_addr
						last_count = count
					end
					#puts lines.map{|k, v|"#{hex(k)}:#{v.length}"}
					@debug_coverage = nil
				end
			when 21  # Ctrl+U
				if @debug_memory_coverage.nil?
					puts "Memory Tracing Turned on"
					@debug_memory_coverage = @memory.dup
				else
					puts "Memory Tracing Turned off. Changes detected:"
					@debug_memory_coverage.zip(@memory).each_with_index do |ms, addr|
						if ms.first != ms.last
							puts "#{hex(addr)}: #{hex(ms.first)} => #{hex(ms.last)}"
						end
					end
					@debug_memory_coverage = nil
				end
			when 22  # Ctrl+V
				puts "Enter ordinal value for character"
				value =  parse_num(gets)
				loop = false
			else
				loop = false
			end
		end
		print "read-input::#{value.ord}\n" if @debug
		value -= 3 if value == 13  # Fix newline on linux
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
					dump_hex = command[1] == "hex"
					if !dump_hex
						dump_bytes = command[1] == "byte"
						File.write(".dump", @memory.pack("#{dump_bytes ? "C" : "S"}*"))
					else
						File.write(".dump", @memory.each_with_index.map{|v,i|"#{hex(i)}: #{hex(v)}".ljust(38) + "DATA\n"}.join)
					end
				when ".decode"
					cnt = -1
					addr_end = 0x10000
					case command.length
					when 1
						addr = @ip
						cnt = 10
					when 2
						addr = parse_num(command[1])
						cnt = 10
					when 3
						addr = parse_num(command[1])
						if command[2].start_with? "0x"
							addr_end = parse_num(command[2])
						else
							cnt = parse_num(command[2])
						end
					end
					while cnt != 0 && addr < addr_end
						addr = prim_debug addr, print_regs=false, print_info=true
						cnt -= 1
					end
				when ".inspect"
					puts "clock=#{@clock} ip=#{hex(@ip)} #{@registers.each_with_index.map{|v,i|"r#{i}=#{hex(v)}"}.join ' '}"
					puts " stack: len=#{@stack.length} | #{@stack.last(10).map{|v|"#{hex(v)}"}.join ' '}"
					# memory if addr[, len] params provided
					ip = @ip
					5.times do
						ip = prim_debug ip
					end
				when ".text"
					#addr = 0x1814
					addr = 0x17ca
					404.times do
						len = @memory[addr]
						print hex(addr) + ": "
						puts '"""' + @memory[addr+1..addr+len].map(&:chr).join + '"""'
						addr += len + 1
					end
				when ".text2"
					addr = 0x1814
					will_title = true
					399.times do
						len = @memory[addr]
						value = @memory[addr+1..addr+len].map(&:chr).join
						start_with_upper = value[0].upcase == value[0]
						if start_with_upper
							if will_title
								print "\n#{hex(addr)} #{value}:"
								will_title = false
							end
						else
							will_title = true
							print " #{value}"
						end
						addr += len + 1
					end
				else
					puts "Unknown command"
					puts " .decode [addr [addrend|cnt]]"
					puts " .dump [byte|hex] - Dump memory content"
					puts " .inspect - Dump status"
					puts " .text - Decode text"
					puts " .exit - Quits repl"
				end
			else
				if not Instruction.const_defined?(command.first.upcase.to_sym)
					puts "Unknown instruction"
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
		if serialized.start_with? "r"
			value = value[1..].to_i
			value >= 0 && value <= 7 ? value + 32768 : nil
		else
			value = parse_num(value)
			value >= 0 && value <= 32767 ? value : nil
		end
	end		

	def prim_debug_ref_serialize(ref)
		if ref <= 32767
			hex(ref)
		elsif ref <= 32775
			"r#{ref-32768}"
		else
			"invalid"
		end
	end		

	def prim_debug ip=nil, print_regs=true, print_info=false
		ip ||= @ip
		opcode = @memory[ip]
		desc = Instruction::FROM_OPCODE[opcode] || Instruction::UNK
		raw = (1+desc.param_num).times.map{|p_idx|hex(@memory[ip + p_idx])}
		params = desc.param_num.times.map{|p_idx|prim_debug_ref_serialize(@memory[ip + 1 + p_idx])}
		print "#{hex(ip)}: " + raw.join(' ').ljust(30) + "#{desc.mnemonic.upcase} #{params.join ' '}".ljust(30)
		if print_info
			if desc.mnemonic == :out && params[0].start_with?("0") && parse_num(params[0]) >= 32 && parse_num(params[0]) < 127
				print "  # '#{parse_num(params[0]).chr}'"
			end
		end
		print "#{@registers.each_with_index.map{|v,i|"r#{i}=#{hex(v)}"}.join ' '}" if print_regs
		print " st:#{hex(@stack.length)}|#{@stack.last(6).map{|v|"#{hex(v)}"}.join ' '}" if print_regs
		print "\n"
		ip + 1 + desc.param_num
	end

	def process_next_instruction
		prim_debug if @debug
		@debug_coverage << @ip unless @debug_coverage.nil?
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
