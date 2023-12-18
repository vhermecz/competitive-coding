require 'set'

INPUT='test'  # part2 has 6405262
INPUT='input'  # part2 has 165680144 perimeter

# read_input
data = File.read(INPUT).split("\n").map do |row|
	dir, n_step, color = row.split(" ")
	[dir, n_step.to_i]
end

data2 = File.read(INPUT).split("\n").map do |row|
	code = row.split(" ").last[2...-1]
	step, dir = [code[0..4].to_i(16), code[-1].to_i]
	[["R", "D", "L", "U"][dir], step]
end

# solve
DIR = {
	R: [0, 1],
	L: [0, -1],
	D: [1, 0],
	U: [-1, 0],
}

def polygonize(data)
	pos = [0, 0]
	fields = []
	data.length.times do |i|
		dir, step = data[i]
		point_dirs = [data[i-1].first.to_sym, data[i].first.to_sym]
		pdir = DIR[dir.to_sym]
		fields << [pos.first + (point_dirs.include?(:L)?1:0), pos.last + (point_dirs.include?(:D)?1:0)]
		pos = [pos.first+pdir.first*step, pos.last+pdir.last*step]
	end
	fields << fields[0]
end

def area(polygon)
  polygon.each_with_index.map do |pos, i|
    prev_pos = polygon[i-1]
    prev_pos.last * pos.first - prev_pos.first * pos.last
  end.sum / 2
end

p area(polygonize(data))
p area(polygonize(data2))

#  18   00:16:39    545      0   03:47:15   4286      0
# 108909
# agonizing dead end with low level approach
# 133125706867777
