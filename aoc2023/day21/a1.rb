require 'set'

#INPUT='test'
INPUT='input'

# read_input
start = nil
maze = File.read(INPUT).split("\n").each_with_index.map do |row, irow|
	start = [irow, row.index('S')] if row.include? "S"
	row.split("")
end

DIRS = [
	[0, 1],
	[1, 0],
	[0, -1],
	[-1, 0],
]

FIN = 26501365

def solve maze, start, parity, limit
	nrow = maze.length
	ncol = maze.first.length

	expand = []
	expand << [start, 0]

	seen = Set.new
	match = Set.new

	while !expand.empty?
		pos, istep = expand.shift
		break if !limit.nil? && istep > limit
		next if seen.include? pos
		seen << pos
		match << pos if istep % 2 == parity
		DIRS.each do |dpos|
			npos = [dpos.first+pos.first, dpos.last+pos.last]
			next if npos.first < 0 || npos.first >= nrow || npos.last < 0 || npos.last >= ncol
			next if maze[npos.first][npos.last] == '#'
			expand << [npos, istep+1]
		end
	end
	match.length
end

p solve(maze, start, 0, 64)

# solve
n_even = solve(maze, start, 1, nil)
n_odd = solve(maze, start, 0, nil)

# p start
# [0, 65, 130].each do |y|
# 	[0, 65, 130].each do |x|
# 		p [y, x, solve(maze, [y,x], 12364)]
# 	end
# end

# tile_x = 1
# tile_y = 1
# tile_t_start = [0, -65+131*tile_x].max + [0, -65+131*tile_y].max
# tile_t_end = [0, -65+131*(tile_x+1)].max + [0, -65+131*(tile_y+1)].max - 2
# p [tile_x, tile_y, tile_t_start, tile_t_end]
# tile_t_start > FIN && tile_t_end < FIN

n_full_axis = (FIN-66)/131
p n_full_axis

full_odd_tiles = ((n_full_axis+1)/2)**2 * 4
full_even_tiles = n_full_axis/2*(n_full_axis/2+1) * 4 + 1
# full_total = n_full_axis*(n_full_axis+1)/2*4+1

t_rem_axis = (FIN-66)%131
t_rem_quad = (FIN-132)%131

p t_rem_axis
p t_rem_quad

result =
	full_even_tiles * n_even + 
	full_odd_tiles * n_odd +
	solve(maze, [  0,   0], 0, t_rem_quad) * (n_full_axis+1) +
	solve(maze, [  0, 130], 0, t_rem_quad) * (n_full_axis+1) +
	solve(maze, [130,   0], 0, t_rem_quad) * (n_full_axis+1) +
	solve(maze, [130, 130], 0, t_rem_quad) * (n_full_axis+1) +
	solve(maze, [  0,   0], 1, t_rem_quad+131) * (n_full_axis) +
	solve(maze, [  0, 130], 1, t_rem_quad+131) * (n_full_axis) +
	solve(maze, [130,   0], 1, t_rem_quad+131) * (n_full_axis) +
	solve(maze, [130, 130], 1, t_rem_quad+131) * (n_full_axis) +
	solve(maze, [  0,  65], 0, t_rem_axis) +
	solve(maze, [ 65,   0], 0, t_rem_axis) +
	solve(maze, [130,  65], 0, t_rem_axis) +
	solve(maze, [ 65, 130], 0, t_rem_axis) +
	0

p result

#  21   00:10:15    799      0   06:27:33   2939      0
# 3820
# 632421652138917
# 633035502727524 @7:23 too-high
# 633035502696648 @7:28 too-high
# 633036294529854 @7:31 too-high
# 633035502762444 @7:40 not-sent too-high
# 633029244440580 @7:42 wrong 5-min
# 632415377201334 did not submit
# 632421646069768 @8:24 wrong 5-min
# 632421612690320 @8:36 wrong 5-min
# 632421646069932 @8:49 wrong 10-min
# @9:33 gave up
# 632421652138917 @12:27 oops, just realized FIN is odd not even
