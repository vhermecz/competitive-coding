require 'set'

#INPUT='test'
INPUT='input'

NBS = [[0, 1, 0], [0, -1, 0], [1, 0, 0], [-1, 0, 0], [0, 0, 1], [0, 0, -1]]
# read_input
data = File.read(INPUT).split("\n").map{|r|r.split(",").map(&:to_i)}

def area(data)
	cnt = 6 * data.length
	data.each do |a|
		data.each do |b|
			next if a == b
			cnt -= 1 if a.zip(b).map{|p1,p2|(p1-p2).abs}.sum == 1
		end
	end
	cnt
end

def filler(data)
	vmin = data.flatten.min-1
	vmax = data.flatten.max+1
	seen = Set.new data
	visit = (vmin..vmax).to_a.repeated_permutation(3).filter do |pos|
		pos.min == vmin or pos.max == vmax
	end
	while not visit.empty?
		pos = visit.pop
		next if seen.include? pos
		seen << pos
		NBS.each do |d|
			npos = pos.zip(d).map(&:sum)
			next if npos.min < vmin or npos.max > vmax
			visit << npos
		end
	end
	(vmin..vmax).to_a.repeated_permutation(3).each do |pos|
		next if seen.include? pos
		data << pos
	end
end

# solve
p area(data)
filler(data)
p area(data)

# 04:46 3396 385
# 18:37 2044 363
