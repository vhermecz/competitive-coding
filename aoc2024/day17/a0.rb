require 'set'

INPUT='test2'
INPUT='input'

# read_input
registers, input = File.read(INPUT).split("\n\n")
registers = registers.split("\n").map do |line|
  line.split(": ").last.to_i
end
input = input.split(": ").last.split(",").map(&:to_i)

def eval_combo(registers, combo)
  # assert combo != 7
  return combo if combo < 4
  registers[combo-4]
end

def run(registers, input, ip)
  output = []
  while ip < input.length-1
    opcode = input[ip]
    operand = input[ip+1]
    case opcode
    when 0
      registers[0] = registers[0] / 2**eval_combo(registers, operand)
    when 1
      registers[1] = registers[1] ^ operand
    when 2
      registers[1] = eval_combo(registers, operand) % 8
    when 3
      ip = operand - 2 if registers[0] != 0
    when 4
      registers[1] = registers[1] ^ registers[2]
    when 5
      output << eval_combo(registers, operand) % 8
    when 6
      registers[1] = registers[0] / 2**eval_combo(registers, operand)
    when 7
      registers[2] = registers[0] / 2**eval_combo(registers, operand)
    else
      nil
    end
    ip += 2
  end
  output
end

x = 0
while true
  r2 = registers.dup
  r2[0] = x
  break if run(r2, input.dup, 0) == input
  x += 1
end
p x

# part 2
# [0, [35184372088831, 0, 0]]["bst", "combo=4::35184372088831"]
# [2, [35184372088831, 7, 0]]["bxl", "B=7", "literal=1"]
# [4, [35184372088831, 6, 0]]["cdiv", "A=35184372088831", "combo=5::6"]
# [6, [35184372088831, 6, 549755813887]]["bxl", "B=6", "literal=5"]
# [8, [35184372088831, 3, 549755813887]]["bxc", "B=3", "B=549755813887"]
# [10, [35184372088831, 549755813884, 549755813887]]["out", "combo=5::549755813884"]
# [12, [35184372088831, 549755813884, 549755813887]]["adiv", "A=35184372088831", "combo=3::3"]
# [14, [4398046511103, 549755813884, 549755813887]]["jnz", "A=4398046511103", "l
#
# "bst", "combo=4::35184372088831"
# "bxl", "B=7", "literal=1"
# "cdiv", "A=35184372088831", "combo=5::6"
# "bxl", "B=6", "literal=5"
# "bxc", "B=3", "B=549755813887"
# "out", "combo=5::549755813884"
# "adiv", "A=35184372088831", "combo=3::3"
# "jnz", "A=4398046511103", "l
#
# while A!=0:
# 	B = reg(A) % 8
# 	B ^= 1
# 	C = A / 2**B
# 	B ^= 5
# 	B ^= C
# 	out(B)
# 	A = A / 8
#
# Started working on decipher in a1.rb
