require 'set'

INPUT='test'
INPUT='input'

input, rules = File.read(INPUT).split("\n\n")
input = input.split("\n").map do |line|
  label, value = line.split(": ")
  [label, value.to_i]
end
$rules = rules.split("\n").map do |line|
  op_a, op, op_b, _, out = line.split(" ")
  [out, [op_a, op, op_b]]
end.to_h

# The needed fixes identified over time
fixes = [
  ["z39", "rpp"],
  ["z23", "kdf"],
  ["z15", "ckj"],
  ["dbp", "fdv"],
]

fixes.each do |sw_a, sw_b|
  tmp = $rules[sw_a]
  $rules[sw_a] = $rules[sw_b]
  $rules[sw_b] = tmp
end

$value = input.to_h

def read(field)
  curr = $value[field]
  return curr unless curr.nil?
  op_a, op, op_b = $rules[field]
  val_a = read(op_a)
  val_b = read(op_b)
  $value[field] = case op
        when 'XOR'
          val_a ^ val_b
        when 'AND'
          val_a & val_b
        when 'OR'
          val_a | val_b
        else
          nil
        end
end


def read_integer(name)
  outs = ($value.keys + $rules.keys).uniq.filter{|v|v.start_with?(name)}.sort
  outs.each_with_index.map do |var, idx|
    read(var) * 2**idx
  end.sum
end

x = read_integer("x")
y = read_integer("y")
z = read_integer("z")
p(x)
p(y)
p(x+y)
p(z)
p(x+y-z)

# Code for finding some faulty output bits
p $rules.to_a.filter{|out, rule|out.start_with?("z") && rule[1]!='XOR' && out!='z45'}
# ["z39", ["vbt", "AND", "vqr"]]
# ["z15", ["x15", "AND", "y15"]]
# ["z23", ["rqt", "OR", "rdt"]]

# Approach
# Used https://dreampuf.github.io/GraphvizOnline/ to inspect the graph
# started writing up linting rules
# 1. zNN rules use XOR
# managed to identify z15, x23, z39
# manually matched the temp-node they been swapped with
# x+y-z hinted on the location of the last bug (~bit 6)
# found that x06, y06 rules were swapped
# done

# Code for visualization
File.open('rules.dot', 'w') do |file|
  file.write("digraph G {\n")
  $rules.to_a.each do |out, rule|
    op_a, op, op_b = rule
    file.write("  #{out}#{op} [label=\"#{op}\"]\n")
    file.write("  #{op_a} -> #{out}#{op}\n")
    file.write("  #{op_b} -> #{out}#{op}\n")
    file.write("  #{out}#{op} -> #{out}\n")
  end
  file.write("}\n")
end

# solve
p fixes.flatten.sort.join(",")
