require 'set'

INPUT='test'  # part2 has 6405262
#INPUT='input'  # part2 has 165680144 perimeter

# read_input
# data = []
# File.open( INPUT ) do |f|
# 	while true do
# 		row = f.gets.strip
# 		break if row.empty?
# 		data << row.split(",").map(&:to_i)
# 	end
# end
data = File.read(INPUT).split("\n").map do |row|
	dir, n_step, color = row.split(" ")
	[dir, n_step.to_i]
end

data2 = File.read(INPUT).split("\n").map do |row|
	code = row.split(" ").last[2...-1]
	step, dir = [code[0..4].to_i(16), code[-1].to_i]
	[["R", "D", "L", "U"][dir], step]
end

DIR = {
	R: [0, 1],
	L: [0, -1],
	D: [1, 0],
	U: [-1, 0],
}

def vadd(v1, v2)
	[v1.first+v2.first, v1.last+v2.last]
end

def polygonize(data)
	pos = [0, 0]

	fields = Set.new
	fields << pos

	data.each do |dir, step|
		step.times do
			pdir = DIR[dir.to_sym]
			pos = [pos.first+pdir.first, pos.last+pdir.last]
			fields << pos
		end
	end
	fields
end

def draw(polygon)
	ys = polygon.map(&:first)
	xs = polygon.map(&:last)
	(ys.min()..ys.max()).to_a.each do |y|
		row = (xs.min()..xs.max()).to_a.map do |x|
			polygon.include?([y,x]) ? "#" : " "
		end.join
		p row
	end
end

def important_dims(polygon)
	[
		[0, [DIR[:R], DIR[:L]]],
		[1, [DIR[:D], DIR[:U]]],
	].map do |dim, dirs|
		important = Set.new
		polygon.each do |pos|
			important << pos[dim] if dirs.map do |pdir|
				polygon.include?([pos.first+pdir.first, pos.last+pdir.last])
			end.any?
		end
		important.sort
	end
end

def compressor(polygon)
	cys, cxs = important_dims(polygon)
	cpolygon = polygon.map do |y,x|
		[cys.index(y), cxs.index(x)]
	end.filter do |y,x|
		!y.nil? && !x.nil?
	end
	[cpolygon, cys, cxs]
end

def filler(polygon)  # BROKEN
	ys = polygon.map(&:first).uniq
	xs = polygon.map(&:last).uniq
	start = [
		polygon.filter{|p|p.last==xs.min}.map(&:first).min * 2 + 1,
		xs.min * 2 + 1,
	]
	expand = []
	seen = Set.new
	expand << start
	while !expand.empty?
		curr = expand.pop
		next if seen.include?(curr)
		next if curr.first.even? && curr.last.even? && polygon.include?([curr.first/2, curr.last/2])
		next if curr.first.even? && !curr.last.even? && polygon.include?([curr.first/2, curr.last/2]) && polygon.include?([curr.first/2, curr.last/2+1])
		next if !curr.first.even? && curr.last.even? && polygon.include?([curr.first/2, curr.last/2]) && polygon.include?([curr.first/2+1, curr.last/2])
		seen << curr
		DIR.values.each do |pdir|
			nxt = [curr.first+pdir.first, curr.last+pdir.last]
			expand << nxt
		end
	end
	seen.filter{|p|p.first.even? && p.last.even?}.map{|y,x|[y/2,x/2]}
end

def compressed_area(outside, inside, cys, cxs)
	pts = outside + inside
	cnt = 0
	# edge
	pts.map do |pt|
		cnt = 1
		right = nil
		if pts.include?(vadd(pt, DIR[:R]))
			right = cxs[pt[1]+1]-cxs[pt[1]]-1
		end
		down = nil
		if pts.include?(vadd(pt, DIR[:D]))
			down = cxs[pt[0]+1]-cxs[pt[0]]-1
		end
		cnt += right if !right.nil?
		cnt += down if !down.nil?
		cnt += right*down if !right.nil? && !down.nil?
		cnt
	end.sum
end
# ys.min()+317
# 

#p data2.map(&:last).sum
fields = polygonize(data)
outside, cys, cxs = compressor(fields)
inside = filler(outside)
p outside
p inside
p compressed_area(outside, inside, cys, cxs)

# solve
#p data
#p fields
p draw(fields)
p
p draw(compressor(fields))
#p filler(fields)

# DEADEND
