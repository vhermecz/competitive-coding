require 'set'

INPUT='test'
#INPUT='input'

# read_input
data = File.read(INPUT).split("\n")

def score(x)
	return (x.ord - 'a'.ord + 1) if x >= 'a'
	x.ord - 'A'.ord + 1 + 26
end

def commonchar(arr)
	arr.map{|x|x.split("").to_set}.reduce(:&).to_a.first
end

def splithalf(str)
	len = str.length
	[str[..len/2-1], str[len/2..]]
end

p(data.map do |line|
	splithalf(line)
end.map do |arr|
	score(commonchar(arr))
end.sum)

p(data.each_slice(3).to_a.map do |arr|
	score(commonchar(arr))
end.sum)

# solve
# 10:33 8252 3033rd
# 14:27 2828 2067th
