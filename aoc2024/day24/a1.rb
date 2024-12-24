require 'set'

INPUT='test'
INPUT='input'

input, rules = File.read(INPUT).split("\n\n")
input = input.split("\n").map do |line|
  label, value = line.split(": ")
  [label, value.to_i]
end.to_h
rules = rules.split("\n").map do |line|
  op_a, op, op_b, _, out = line.split(" ")
  [out, [op_a, op, op_b]]
end.to_h

class Integer
  def to_wire(prefix)
    self.to_s(2).rjust(45, "0").split("").reverse.each_with_index.map{|v, i|["#{prefix}#{i.to_s.rjust(2, '0')}", v.to_i]}.to_h
  end
end

def eval(x, y, rules)
  op_a_rules = rules.to_a.map{|key, (op_a, _, _)|[op_a, key]}
  op_b_rules = rules.to_a.map{|key, (_, _, op_b)|[op_b, key]}
  op_index = (op_a_rules + op_b_rules).group_by{|k, _| k}.to_a.map{|k, v| [k, v.map(&:last)]}.to_h
  deps = rules.to_a.map{|key, (op_a, _, op_b)|[key, [op_a, op_b]]}.to_h
  values = x.to_wire("x").merge(y.to_wire("y"))
  expand = []
  value_set = values.keys.to_set
  value_set.each do |v|
    op_index[v].each do |v2|
      expand << v2 if deps[v2].all?{|dep|value_set.include?(dep)}
    end
  end
  until expand.empty?
    r = expand.pop
    op_a, op, op_b = rules[r]
    a = values[op_a]
    b = values[op_b]
    values[r] = case op
                   when 'XOR'
                     a ^ b
                   when 'AND'
                     a & b
                   when 'OR'
                     a | b
                   else
                     nil
                end
    value_set << r
    (op_index[r] || []).each do |v|
      expand << v if deps[v].all?{|dep|value_set.include?(dep)}
    end
  end
  result_registers = values.keys.filter{|k, _|k.start_with?("z")}.sort
  return -1 unless result_registers.length == 46
  result_registers.each_with_index.map do |r, i|
    values[r] * 2**i
  end.sum
end

def read_integer(input, name)
  outs = input.keys.filter{|v|v.start_with?(name)}.sort
  outs.each_with_index.map do |var, idx|
    input[var] * 2**idx
  end.sum
end

def swap(rules, a, b)
  tmp = rules[a]
  rules[a] = rules[b]
  rules[b] = tmp
end

x = read_integer(input, "x")
y = read_integer(input, "y")
p eval(x, y, rules)

def first_bug_fuzz(rules)
  base = "0".rjust(46, "0").split("").map{|i| i.to_i}
  20.times do
    x = rand(0...2**45)
    y = rand(0...2**45)
    diff = (x + y) ^ eval(x, y, rules)
    bit_diff = diff.to_s(2).rjust(46, "0").split("").map{|i| i.to_i}
    base = base.zip(bit_diff).map{|a, b| a | b}
  end
  base.reverse.index(1)
end

def nearby_registers(rules, bit)
  result = level = [
    "z#{(bit+0).to_s.rjust(2, '0')}",
    "z#{(bit+1).to_s.rjust(2, '0')}",
  ]
  4.times do
    next_level = []
    level.each do |r|
      op_a, _, op_b = rules[r]
      next if op_a.nil?
      next_level << op_a
      next_level << op_b
    end
    level = next_level.uniq
    result = result + level
  end
  result.uniq.filter{|v|v[0]!='x' && v[0]!='y'}
end

def part2_solver(rules, debug=false)
  fixes = []
  until first_bug_fuzz(rules).nil?
    curr = first_bug_fuzz(rules)
    registers = nearby_registers(rules, curr)
    p ["Searching around bit #{curr}", registers] if debug
    registers.combination(2).each do |a, b|
      local_rules = rules.dup
      swap(local_rules, a, b)
      local_curr = first_bug_fuzz(local_rules)
      if local_curr.nil? || curr < local_curr
        p "Found:  #{a}, #{b} (seeing #{local_curr})" if debug
        fixes += [a, b]
        rules = local_rules
        break
      end
    end
  end
  fixes
end

p part2_solver(rules).sort.join(",")
