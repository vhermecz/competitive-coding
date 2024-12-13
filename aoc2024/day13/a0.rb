require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |game|
  a, b, p = game.split("\n")
  a = a.split(": ", 2).last.split(", ", 2).map{|v|v.split("+").last}.map(&:to_i)
  b = b.split(": ", 2).last.split(", ", 2).map{|v|v.split("+").last}.map(&:to_i)
  p = p.split(": ", 2).last.split(", ", 2).map{|v|v.split("=").last}.map(&:to_i)
  [a, b, p]
end

p1 = data.map do |a, b, p|
  r = 100.times.map do |na|
    100.times.map do |nb|
      cv = [a.first*na + b.first*nb, a.last*na+b.last*nb]
      cost = na*3+nb
      cost if cv == p
    end
  end.flatten(1).compact
end

p p1.flatten.sum

data = data.each do |v|
  v[2][0] = v[2][0]+10000000000000
  v[2][1] = v[2][1]+10000000000000
end

p2 = data.map do |a, b, p|
  nb = (p.last*a.first - a.last*p.first) / (a.first*b.last - a.last*b.first)
  next if nb * (a.first*b.last - a.last*b.first) != p.last*a.first - a.last*p.first
  na = (p.first - b.first * nb) / a.first
  na*3+nb
end.compact.sum

p p2

# 29023
# 96787395375634



# a.first*na + b.first*nb = p.first
# a.last*na + b.last*nb = p.past
# min(3*na+nb)

# a.last*(p.first - b.first*nb) + a.first*b.last*nb = p.last*a.first
# a.last*p.first - a.last*b.first*nb+ a.first*b.last*nb= p.last*a.first
# (a.first*b.last - a.last*b.first) * nb = p.last*a.first - a.last*p.first
# nb = (p.last*a.first - a.last*p.first) / (a.first*b.last - a.last*b.first)
