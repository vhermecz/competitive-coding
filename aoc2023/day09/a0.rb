require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map{|row|row.split(" ").map(&:to_i)}

def difftree seq
	seqs = []
	curr = seq
	while curr.to_set.to_a != [0]
		seqs << curr
		curr = curr.each_cons(2).map{|i1, i2|i2 - i1}
	end
	seqs
end

def extrapol seq
	difftree(seq).map(&:last)
end

def prepol seq
	delta = 0
	difftree(seq).reverse.map do |pre|
		delta = pre.first - delta
	end
end

# solve
p data.map{|datum|extrapol(datum).sum}.sum
p data.map{|datum|prepol(datum).last}.sum

# Argh, mega super brainfreeze in the morning
#  9   00:09:16   1079      0   00:15:49   1655      0
# 2101499000
# 1089
