require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.gsub(":", "").gsub(",", "").split(" ")
	row = [row[2], row[3], row[8], row[9]]
	sx, sy, bx, by = row.map{|i|i.split("=").last.to_i}
	[[sx, sy], [bx, by]]
end

# solve
dists = data.map do |info|
	[info, info.first.zip(info.last).map{|a,b|(a-b).abs}.sum]
end
yslice = INPUT=='input'? 2000000:10

def slice_ranges(dists, y, skip_beacon:false)
	dists.map do |info, r|
		s, b = info
		h=(s[1]-y).abs
		ry=r-h
		lo = s[0]-ry
		hi = s[0]+ry
		lo+=1 if lo == b[0] && skip_beacon
		hi-=1 if hi == b[0] && skip_beacon
		(lo..hi) if lo <= hi
	end.compact
end

def merge_ranges(ranges)
	res = []
	ranges = ranges.sort_by{|k|k.first*1000000000+k.last}
	s = ranges.first.first
	e = ranges.first.last
	ranges.each do |range|
		if e < range.first - 1
			res << (s..e)
			e = s = range.first
		end
		e = [range.last, e].max
	end
	res << (s..e)
	res
end

ranges = merge_ranges(slice_ranges(dists, yslice, skip_beacon:true))
p ranges.map{|range|range.last - range.first + 1}.sum

40000001.times.each do |y|
	ranges = merge_ranges(slice_ranges(dists, y))
	if ranges.length == 2
		x = ranges.last.first - 1
		p 4000000*x + y
		break
	end
end

# 20:10 5135731 bad (y=10)
# 21:12 5147333 721
# 42:01 13734006908372 409
