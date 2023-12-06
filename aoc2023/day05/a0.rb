require 'set'

#INPUT='test'
INPUT='input'

sections = File.read(INPUT).split("\n\n")
points_raw = sections.first.split(": ").last.split(" ").map(&:to_i)
points = points_raw.map do |num|
	["seed", num]
end
points_pairs = points_raw.each_slice(2).map do |range|
	["seed", range]
end	
mappers = sections[1..].map do |section|
	name, ranges = section.split(":\n")
	mapping = name.split(" ").first.split("-to-")
	ranges = ranges.split("\n").map do |range|
		range.split(" ").map(&:to_i)
	end
	[mapping[0], [mapping[1], ranges]]
end.to_h

def map_point(point, mappers)
	#p point
	new_cat, mapper = mappers[point.first]
	mapper.each do |en, st, le|
		return [new_cat, point.last - st + en] if point.last >= st && point.last < st + le
	end
	[new_cat, point.last]
end

def map_point_range_once(new_cat, range, mapper)
	p_st, p_len = range
	mapper.each do |dst, src, len|
		if p_st >= src && p_st < src + len
			r_len = [p_len, (src + len) - p_st].min
			r_st = p_st - src + dst
			p_st += r_len
			p_len -= r_len
			return [[new_cat, [r_st, r_len]], [p_st, p_len]]
		end
	end
	nxt_map_range = mapper.map{|mapping|mapping[1]}.filter{|src|src > p_st}.min
	nxt_map_range = p_st + p_len if nxt_map_range.nil?
	r_len = [p_len, nxt_map_range - p_st].min
	r_st = p_st
	p_st += r_len
	p_len -= r_len
	return [[new_cat, [r_st, r_len]], [p_st, p_len]]	
end

def map_point_range(point, mappers)
	new_cat, mapper = mappers[point.first]
	range = point.last
	res = []
	while range.last > 0
		res_point, range = map_point_range_once(new_cat, range, mapper)
		res << res_point
	end
	res
end

# solve
while points.first.first != "location"
	points = points.map do |point|
		map_point(point, mappers)
	end
end
p points.map(&:last).min

while points_pairs.first.first != "location"
	points_pairs = points_pairs.map do |points_pair|
		map_point_range(points_pair, mappers)
	end.flatten(1)
end
p points_pairs.map{|x|x[1][0]}.min

#  5   00:18:31   1122      0   00:58:16   1346      0
# 322500873
# 108956227
