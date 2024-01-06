
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

class MagicVm
	attr_reader :memory, :registers, :stack
	attr_accessor :debug, :ip
	def initialize(snapshot)
		@memory = snapshot.unpack("S<*")  # TODO size?
		@registers = [0] * 8  # TODO initial value?
		@stack = []  # TODO initial value?
		@ip = 0
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

	def prim_debug_ref(ref)
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
		params = desc.param_num.times.map{|p_idx|prim_debug_ref(@memory[@ip + 1 + p_idx])}
		print "<@#{@ip}:#{@registers} #{desc.mnemonic.upcase} #{params.join ' '}>\n"
	end

	def process_next_instruction
		prim_debug if @debug
		op = @memory[@ip]
		a = @memory[@ip + 1]
		b = @memory[@ip + 2]
		c = @memory[@ip + 3]
		case op
		when Instruction::HALT.opcode
			prim_halt
		when Instruction::SET.opcode
			raise RuntimeError.new("Unspecified") if @memory[@ip + 1] <= 32767
			prim_write(a, prim_read(b))
			@ip += 3
		when Instruction::JMP.opcode
			@ip = prim_read(a)
		when Instruction::JT.opcode
			@ip = ((prim_read(a) != 0) ? prim_read(b) : (@ip + 3))
		when Instruction::JF.opcode
			@ip = ((prim_read(a) == 0) ? prim_read(b) : (@ip + 3))
		when Instruction::OUT.opcode
			print(prim_read(a).chr)
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
#vm.ip = 558
p vm.registers
vm.execute
