require 'set'

INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map{|row|row.split(" ").map(&:to_i)}

def extrapol seq
	curr = seq
	seqs = []
	while curr.to_set.to_a != [0]
		seqs << curr
		curr = curr.each_cons(2).map do |i1, i2|
			i2 - i1
		end
	end
	seqs.map(&:last).sum
end

def prepol seq
	curr = seq
	seqs = []
	while curr.to_set.to_a != [0]
		seqs << curr
		curr = curr.each_cons(2).map do |i1, i2|
			i2 - i1
		end
	end
	res = []
	delta = 0
	seqs.reverse.each do |pre|
		delta = pre.first - delta
		res << delta
	end
	delta
end

# solve
part1 = data.map do |datum|
	extrapol datum
end

part2 = data.map do |datum|
	prepol datum
end

p part1.sum
p part2.sum

# Argh, mega super brainfreeze in the morning
#  9   00:09:16   1079      0   00:15:49   1655      0
# 2101499000
# 1089
