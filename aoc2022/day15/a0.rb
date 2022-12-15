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
		#p [s,r,h,ry]
		lo = s[0]-ry
		hi = s[0]+ry
		lo+=1 if lo == b[0] && skip_beacon
		hi-=1 if hi == b[0] && skip_beacon
		(lo..hi) if lo <= hi
	end.compact
end

def holey(ranges)
	ranges = ranges.sort_by{|k|k.first*1000000000+k.last}
	px = ranges.first.first - 1
	ranges.each do |range|
		return px+1 if px < range.first - 1
		px = [range.last, px].max
	end
	nil
end

ranges = slice_ranges(dists, yslice, skip_beacon:true)
ranges = ranges.map(&:to_a).flatten.to_set
p ranges.length

(0..4000000).to_a.each do |i|
	ranges = slice_ranges(dists, i)
	#p i
	hole = holey(ranges)
	#p [i, hole]
	if !hole.nil?
		p hole*4000000 + i
		break
	end
end

# 20:10 5135731 bad (y=10)
# 21:12 5147333 721
# 42:01 13734006908372 409
