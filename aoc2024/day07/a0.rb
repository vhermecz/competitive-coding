require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
  score, factors = line.split(": ")
  factors = factors.split(" ").map(&:to_i)
  [score.to_i, factors]
end

def eval(factors, operators)
  current = factors[0]
  operators.length.times do |i|
    if operators[i] == "+"
      current += factors[i+1]
    elsif operators[i] == "*"
      current *= factors[i+1]
    else
      current = (current.to_s + factors[i+1].to_s).to_i
    end
  end
  current
end

def attempt(score, factors, operators)
  operators.repeated_permutation(factors.length-1).to_a.each do |operators|
    return 1 if eval(factors, operators) == score
  end
  0
end

def solve(data, operators)
  data.map do |score, factors|
    attempt(score, factors, operators) * score
  end.sum
end

p solve(data, ["+", "*"])
p solve(data, ["+", "*", "|"])

# 1038838357795
# 254136560217241
