require 'set'

#INPUT='test'
INPUT='input'

start = nil
maze = File.read(INPUT).split("\n").each_with_index.map do |row, irow|
	if row.include? "S"
		start = [irow, row.index('S')]
		row = row.gsub('S', '.')
	end 
	row.split("")
end

DIRS = [
	[0, 1],
	[1, 0],
	[0, -1],
	[-1, 0],
]

nrow = maze.length
ncol = maze.first.length

expand = []
#start = [0, 65]
expand << [start, 0]

seen = Set.new
match = Set.new
edges = []

while !expand.empty?
	pos, istep = expand.shift
	if pos.first < 0 || pos.first >= nrow || pos.last < 0 || pos.last >= ncol
		edges << [istep, pos]
		next
	end
	next if seen.include? pos
	seen << pos
	match << pos if istep % 2 == 0 && istep <= 64
	DIRS.each do |dpos|
		npos = [dpos.first+pos.first, dpos.last+pos.last]
		next if maze[npos.first%nrow][npos.last%ncol] == '#'
		expand << [npos, istep+1]
	end
end

#prune
real_edges = []
edges.sort.each do |istep, pos|
	can_reach = real_edges.filter do |irstep, rpos|
		vdist = (rpos.first-pos.first).abs+(rpos.last-pos.last).abs
		tdist = istep-irstep
		vdist <= tdist
	end.any?
	real_edges << [istep, pos] if !can_reach
end

# solve
p match.length
#p edges
p real_edges

# Realized here that input has a trick: side and middle rows/cols are avenues (empty)
# So connections between tiles are trivial, no need to compute exit profiles
