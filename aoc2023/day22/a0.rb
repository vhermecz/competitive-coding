require 'set'

INPUT='test'
INPUT='input'

# x,y,z
# ground z=0 (sizes: 2..3)
# input has one brick with size==1 (sizes: 1..5)
#  1..308
#  0..9
#  0..9

# read_input
bricks = File.read(INPUT).split("\n").map do |brick|
	f, t = brick.split("~")
	f = f.split(",").map(&:to_i)
	t = t.split(",").map(&:to_i)
	f.zip(t).map(&:sort)
end

dim_x = bricks.map{|x|x[0]}.flatten.minmax
dim_y = bricks.map{|x|x[1]}.flatten.minmax
dim_z = bricks.map{|x|x[2]}.flatten.minmax

fail if dim_x.first != 0
fail if dim_y.first != 0

# Create top height and index view
top_height = (dim_y.last+1).times.map{[0]*(dim_x.last+1)}
top_index = (dim_y.last+1).times.map{[0]*(dim_x.last+1)}

bricks = bricks.sort{|x,y|x.last.first <=> y.last.first}

# Compute dependency graph
dep_on = bricks.each_with_index.map do |brick, i_brick|
	i_brick = i_brick + 1
	b_dim_x, b_dim_y, b_dim_z = brick
	max_under = Range.new(*b_dim_y).to_a.map do |y|
		Range.new(*b_dim_x).to_a.map do |x|
			top_height[y][x]
		end
	end.flatten.max
	support = Range.new(*b_dim_y).to_a.map do |y|
		Range.new(*b_dim_x).to_a.map do |x|
			top_index[y][x] if max_under == top_height[y][x]
		end
	end.flatten.compact.uniq
	my_height = b_dim_z.last - b_dim_z.first + 1
	Range.new(*b_dim_y).to_a.map do |y|
		Range.new(*b_dim_x).to_a.map do |x|
			top_height[y][x] = max_under + my_height
			top_index[y][x] = i_brick
		end
	end
	[i_brick, support]
end

# Depgraph xform in to out
dep_edges = dep_on.each.map do |i_b, ins|
	ins.map do |in_|
		[in_, i_b]
	end
end.flatten(1).group_by(&:first).map do |k, v|
	[k, v.map(&:last)]
end.to_h

# Reachability anal if we remove brick i
reach = bricks.length.times.each.map do |i_brick|
	i_brick += 1
	seen = Set.new
	expand = [0]
	while !expand.empty?
		curr = expand.pop
		seen << curr
		next if curr == i_brick
		(dep_edges[curr] || []).each do |nxt|
			expand << nxt
		end
	end
	seen.length - 1
end

# Count of bricks that can be removed without others falling (one at a time)
p reach.filter{|x|x==bricks.length}.length
# For every removed, how many would fall in total
p reach.map{|x|bricks.length-x}.sum

#  22   00:42:09    766      0   00:43:33    406      0
# 441
# 80778
