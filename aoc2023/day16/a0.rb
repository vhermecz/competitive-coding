require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row.split("")
end

DIRS = {
	N: [-1, 0],
	S: [1, 0],
	E: [0, 1],
	W: [0, -1],
}

MIRROR = {
	'/': {
		E: :N,
		N: :E,
		S: :W,
		W: :S, 
	},
	'\\': {
		E: :S,
		S: :E,
		W: :N,
		N: :W,
	}
}

def dbg(v)
	v.each do |v2|
		puts v2.join ""
	end
end

def energized(data, start_pos, start_dir)
	n_row = data.length
	n_col = data.first.length
	visited = Set.new
	seen = Set.new
	expand = [[start_pos, start_dir]]
	while !expand.empty?
		curr_pos, curr_dir = expand.pop
		next if seen.include? [curr_pos, curr_dir]
		seen << [curr_pos, curr_dir]
		next_pos = [curr_pos.first+DIRS[curr_dir].first, curr_pos.last+DIRS[curr_dir].last]
		next if !next_pos.first.between?(0, n_row-1) || !next_pos.last.between?(0, n_col-1)
		visited << next_pos
		item = data[next_pos.first][next_pos.last]
		if item == "|" && [:E, :W].include?(curr_dir)
			expand << [next_pos, :S]
			expand << [next_pos, :N]
		elsif item == '-' && [:S, :N].include?(curr_dir)
			expand << [next_pos, :E]
			expand << [next_pos, :W]
		elsif item == '/' || item == '\\'
			expand << [next_pos, MIRROR[item.to_sym][curr_dir]]
		else
			expand << [next_pos, curr_dir]
		end
	end
	visited.length
end

# solve
p energized(data, [0, -1], :E)
n_row = data.length
n_col = data.first.length
part2 = (
	n_row.times.map{|i|[[i, -1], :E]}+
	n_row.times.map{|i|[[i, n_col], :W]}+
	n_col.times.map{|i|[[-1, i], :S]}+
	n_col.times.map{|i|[[n_row, i], :N]}
).map do |pos, dir|
	energized(data, pos, dir)
end.max

p part2

#  16   00:52:45   3264      0   01:01:50   2958      0
# cheesus christ, #nobraintoday
# 8406 bad 0,0 skipped
# 8390 bad 0,-1 counted
# 8389
# 8564
