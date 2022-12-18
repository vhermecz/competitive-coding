require 'set'

#INPUT='test'
INPUT='input'

NB = [[0, 1, 0], [0, -1, 0], [1, 0, 0], [-1, 0, 0], [0, 0, 1], [0, 0, -1]]
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
	vmin = data.flatten.min
	vmax = data.flatten.max
	seen = Set.new data
	visit = []
	(vmin-1..vmax+1).to_a.each do |i|
		(vmin-1..vmax+1).to_a.each do |j| 
			visit << [i, j, vmin-1]
			visit << [i, j, vmax+1]
			visit << [vmin-1, i, j]
			visit << [vmax+1, i, j]
			visit << [i, vmin-1, j]
			visit << [i, vmax+1, j]
		end
	end
	while not visit.empty?
		pos = visit.pop
		next if seen.include? pos
		seen << pos
		NB.each do |d|
			npos = pos.zip(d).map(&:sum)
			next if npos.min < vmin-1 or npos.max > vmax+1
			visit << npos
		end
	end
	(vmin-1..vmax+1).each do |i|
		(vmin-1..vmax+1).each do |j|
			(vmin-1..vmax+1).each do |k|
				next if seen.include? [i,j,k]
				data << [i,j,k]
			end
		end
	end
end

# solve
p area(data)
filler(data)
p area(data)

# 04:46 3396 385
# 18:37 2044 363
