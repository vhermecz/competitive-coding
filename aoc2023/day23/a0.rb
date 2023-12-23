require 'set'

INPUT='test'
INPUT='input'

# read_input
maze = File.read(INPUT).split("\n").map do |row|
	row.split("")
end

n_row = maze.length
n_col = maze.first.length

N = 0
E = 1
S = 2
W = 3

DIRS = [
	[-1, 0],
	[0, 1],
	[1, 0],
	[0, -1],
]

SLOPES = {
	'>' => E,
	"^" => N,
	'v' => S,
	'<' => W,
}

seen = Set.new
start = [0, 1]
stop = [n_row-1, n_col-2]
trail = []
trail << [start, 0]
best = -1

while !trail.empty?
	#p trail.length
	pos, dir = trail.pop()
	if pos == stop
		tlen = trail.length
		p ["E", best, tlen, trail[0..6]]
		best = tlen if tlen > best
		next
	end
	if dir == 4
		seen.delete pos
		next
	end
	if dir == 0
		seen << pos
	end
	trail << [pos, dir+1]
	dpos = DIRS[dir]
	npos = [pos.first+dpos.first, pos.last+dpos.last]
	next if npos.first < 0 || npos.first >= n_row || npos.last < 0 || npos.last >= n_col
	field = maze[npos.first][npos.last]
	next if field == '#'
	#next if field != '.' && dir != SLOPES[field]
	next if seen.include? npos
	trail << [npos, 0]
end

# solve
p best

