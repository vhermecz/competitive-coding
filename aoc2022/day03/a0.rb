require 'set'

INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |line|
	a = line.length
	[line[..a/2-1], line[a/2..]]
end

def score(x)
	return (x.ord - 'a'.ord + 1) if x >= 'a'
	x.ord - 'A'.ord + 1 + 26
end

b = data.map do |row|
	e = row.map{|x|x.split("").to_set}
	common = e[0] & e[1]
	score(common.to_a[0])
end

p b.sum

data2 = data.map{|x|x[0]+x[1]}
c= data2.each_slice(3).to_a.map do |row|
	e = row.map{|x|x.split("").to_set}
	common = e[0] & e[1] & e[2]
	score(common.to_a[0])
end
p c.sum

# solve
# 10:33 8252 3033rd
# 14:27 2828 2067th
