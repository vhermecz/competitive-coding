require 'set'

# INPUT='test2'
INPUT='input'

DEBUG = false

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

def run(registers, input)
  ip = 0
  output = []
  p(input) if DEBUG
  while ip < input.length-1
    opcode = input[ip]
    operand = input[ip+1]
    print([ip, registers]) if DEBUG
    case opcode
    when 0
      p(["adiv", "A=#{registers[0]}", "combo=#{operand}::#{eval_combo(registers, operand)}"]) if DEBUG
      registers[0] = registers[0] / 2**eval_combo(registers, operand)
    when 1
      p(["bxl", "B=#{registers[1]}", "literal=#{operand}"]) if DEBUG
      registers[1] = registers[1] ^ operand
    when 2
      p(["bst", "combo=#{operand}::#{eval_combo(registers, operand)}"]) if DEBUG
      registers[1] = eval_combo(registers, operand) % 8
    when 3
      p(["jnz", "A=#{registers[0]}", "literal=#{operand}"]) if DEBUG
      ip = operand - 2 if registers[0] != 0
    when 4
      p(["bxc", "B=#{registers[1]}", "B=#{registers[2]}"]) if DEBUG
      registers[1] = registers[1] ^ registers[2]
    when 5
      p(["out", "combo=#{operand}::#{eval_combo(registers, operand)}"]) if DEBUG
      output << eval_combo(registers, operand) % 8
    when 6
      p(["bdiv", "A=#{registers[0]}", "combo=#{operand}::#{eval_combo(registers, operand)}"]) if DEBUG
      registers[1] = registers[0] / 2**eval_combo(registers, operand)
    when 7
      p(["cdiv", "A=#{registers[0]}", "combo=#{operand}::#{eval_combo(registers, operand)}"]) if DEBUG
      registers[2] = registers[0] / 2**eval_combo(registers, operand)
    else
      nil
    end
    ip += 2
  end
  output
end

def decipher(input, registers, current)
  base = current.zip(current.length.times).map{|v,i|v*8**i}.sum*8
  8.times do |i|
    r = registers.dup
    r[0] = base + i
    output = run(r, input.dup)
    if output == input
      return base + i
    end
    if input[-output.length..-1] == output
      result = decipher(input, registers, [i] + current)
      return result unless result.nil?
    end
  end
  nil
end

p run(registers, input).join ","
p decipher(input, registers, [])
