require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map(&:to_i)

# solve
def solver(data, decoder, itercnt)
	l = data.length
	data = data.map{|i|i*decoder}.each_with_index.to_a
	origi = data[0..]
	itercnt.times do
		origi.each do |n, i|
			pos = data.index([n, i])
			n = n % (l-1)
			while n != 0
				dir = n/n.abs
				npos = (pos + dir) % l
				data[pos], data[npos] = data[npos], data[pos]
				pos = npos
				n -= dir
			end
		end
	end
	data = data.map(&:first)
	pos = data.index(0)
	[1000,2000,3000].map{|i|data[(pos+i) % l]}.sum
end

p solver(data, 1, 1)
p solver(data, 811589153, 10)

# -7464 bad (smart algo, wanted to patch in one go)
# 2307 bad whaaat?!
# 4024 (-1 per full rotations, bad)
# mkay, list is not uniq. though, I actually have seen that, did not realize conseq
# 01:44:17 11073 2715
# -3405428085988 bad (new order after each iteration)
# 01:49:06 11102539613040 2272
