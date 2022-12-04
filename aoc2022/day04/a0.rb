require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
	line.split(",").map do |pairs|
		pairs.split("-").map(&:to_i)
	end
end

def contains(a, b)
	a[0] <= b[0] and a[1] >= b[1]
end

def atall(a, b)
	((a[0]..a[1]).to_set & (b[0]..b[1]).to_set).length > 0
end

p(data.filter do |pair|
	contains(pair[0], pair[1]) or contains(pair[1], pair[0])
end.length)

p(data.filter do |pair|
	atall(pair[0], pair[1])
end.length)

# 00:03:57 500 766
# 00:06:14 314 bad
# 00:07:18 815 1247
