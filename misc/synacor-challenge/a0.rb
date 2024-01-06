
module OpCode
  HALT = 0
  SET = 1
  PUSH = 2
  POP = 3
  EQ = 4
  GT = 5
  JMP = 6
  JT = 7
  JF = 8
  ADD = 9
  MULT = 10
  MOD = 11
  AND = 12
  OR = 13
  NOT = 14
  RMEM = 15
  WMEM = 16
  CALL = 17
  RET = 18
  OUT = 19
  IN = 20
  NOOP = 21
end

class MagicVm
	attr_reader :memory, :resterters, :stack
	def initialize(snapshot)
		@memory = snapshot.unpack("S<*")  # TODO size?
		@registers = [0] * 8  # TODO initial value?
		@stack = []  # TODO initial value?
		@ip = 0
	end

	def self.from_snapshot_file(filename)
		self.new(File.read(filename))
	end

	def prim_read(address)
		if address <= 32767
			address
		elsif address <= 32775
			@registers[address-32768]
		else
			raise RuntimeError.new("Invalid read address")
		end
	end

	def prim_halt()
		raise RuntimeError.new("HALT")
	end

	def process_op
		op = @memory[@ip]
		case op
		when OpCode::HALT
			prim_halt
		when OpCode::OUT
			value = prim_read(@memory[@ip + 1])
			print(value.chr)
			@ip += 2
		when OpCode::NOOP
			@ip += 1
		else
			raise RuntimeError.new("Unimplemented opcode #{op}")
		end
	end

	def execute
		process_op while true
	end
end

vm = MagicVm.from_snapshot_file("challenge.bin")
vm.execute
