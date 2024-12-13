require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |game|
  game.split("\n").map do |line|
    line.split(": ").last.split(", ").map do |v|
      v.split(/[+=]/).last
    end.map(&:to_i)
  end
end

def solve(data, extra=0)
  data.map do |a, b, p|
    p = p.map{|v|v+extra}
    v1 = p.last * a.first - a.last * p.first
    v2 = a.first * b.last - a.last * b.first
    next if v1 % v2 != 0
    nb = v1 / v2
    v3 = p.first - b.first * nb
    next if v3 % v3 != 0
    na = v3 / a.first
    3 * na + nb
  end.compact.sum
end

p solve(data)
p solve(data, 10_000_000_000_000)

# 29023
# 96787395375634
