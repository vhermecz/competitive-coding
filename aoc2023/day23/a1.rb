require 'set'

#INPUT='test'
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

def get_splits maze
	n_row = maze.length
	n_col = maze.first.length
	splits = []
	(1..n_row-2).each do |y|
		(1..n_col-2).each do |x|
			nbs = DIRS.filter do |dy, dx|
				maze[y+dy][x+dx] != "#"
			end.length
			splits << [y, x] if nbs > 2 && maze[y][x] != '#'
		end
	end
	splits
end

def longest_route maze, start, stop, upslope=false, pgraph=false
	n_row = maze.length
	n_col = maze.first.length

	wh_cache = {}
	splits = get_splits(maze).to_set
	splits << start
	splits << stop

	seen = Set.new
	trail = []
	trail << [start, 0, 0]
	best = -1

	while !trail.empty?
		pos, dir, tlen = trail.pop()
		# detect finish
		if pos == stop && tlen > best
			best = tlen
			next
		end
		# manage seen
		if dir == 4
			seen.delete pos
			next
		end
		if dir == 0
			seen << pos
		end
		# track
		trail << [pos, dir+1, tlen]
		if !wh_cache[[pos,dir]].nil?
			npos, nstep = wh_cache[[pos,dir]]
			next if seen.include? npos
			trail << [npos, 0, tlen+nstep]
		else
			dpos = DIRS[dir]
			npos = [pos.first+dpos.first, pos.last+dpos.last]
			next if npos.first < 0 || npos.first >= n_row || npos.last < 0 || npos.last >= n_col
			field = maze[npos.first][npos.last]
			next if field == '#'
			next if field != '.' && dir != SLOPES[field] && !upslope
			if splits.include?(npos)  # create a wormhole
				idx = trail.length - 2
				idx -= 1 while !splits.include?(trail[idx].first)
				wh_open = trail[idx].first
				next if wh_open == npos
				wh_open_dir = trail[idx][1] - 1
				wh_len = 1 + tlen - trail[idx].last
				wh_cache[[wh_open, wh_open_dir]] = [npos, wh_len]
				wh_cache[[npos, (dir+2)%4]] = [wh_open, wh_len] if upslope
			end
			next if seen.include? npos
			trail << [npos, 0, tlen+1]
		end
	end
	if pgraph
		puts "graph G {"
		splits = splits.sort
		wh_cache.entries.map do |k, v|
			[k.first, v.first].map{|x|splits.index(x)}.sort + [v.last]
		end.uniq.each do |a, b, c|
			print "  ", a, " -- ", b, "[label=", c, "]\n"
		end
		scale = 14.1 / n_row
		p
		splits.each_with_index do |s, idx|
			print "  ", idx, " [pos=\"", (s.last*scale).round(1), ",", ((n_row-s.first-1)*scale).round(1), "\",pin=true]\n"
		end
		puts "}"
	end
	best
end

# solve
start = [0, 1]
stop = [n_row-1, n_col-2]
p longest_route maze, start, stop, false
p longest_route maze, start, stop, true

#  23   00:17:40    500      0   03:07:13   2193      0
# 1998
# 5670 wrong @39:39
# 5726 wrong @41:48
# 5854 wrong @48:36
# 6170 not-sent @7:08
# 6170 wrong @7:21
# @8:00 taking a break
# 6434
