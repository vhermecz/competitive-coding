require 'set'
require 'rb_heap'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row.split("").map(&:to_i)
end


E = 1
S = 2
W = 3
N = 0

DIR = {
	E => [0, 1],
	S => [1, 0],
	W => [0, -1],
	N => [-1, 0],
}

def bestroute data, is_ultra
	n_row = data.length
	n_col = data.first.length
	cost = {}
	seen = Set.new
	start_pos = [0, 0]
	expand = Heap.new{|a,b|a.first<b.first}
	expand << [0, [start_pos, E, 0]]
	expand << [0, [start_pos, S, 0]]
	while !expand.empty?
		curr_cost, curr_state = expand.pop
		cost[curr_state] = curr_cost
		next if seen.include?(curr_state)
		seen << curr_state
		curr_pos, curr_dir, curr_cons = curr_state
		if curr_pos == [n_row-1, n_col-1] && (!is_ultra || curr_cons >= 4)
			return curr_cost
		end
		steps = []
		steps << 0 if curr_cons < 3  && !is_ultra
		steps << 0 if curr_cons < 10 && is_ultra
		steps << -1 if curr_cons >= 4 || !is_ultra
		steps << 1 if curr_cons >= 4 || !is_ultra
		steps.each do |step|
			next_dir = (curr_dir + step) % 4
			next_cons = step == 0 ? curr_cons + 1 : 1
			next_pos = [curr_pos.first+DIR[next_dir].first, curr_pos.last+DIR[next_dir].last]
			next if !next_pos.first.between?(0, n_row-1) || !next_pos.last.between?(0, n_col-1)
			next_state = [next_pos, next_dir, next_cons]
			next_cost = cost[curr_state] + data[next_pos.first][next_pos.last]
			expand << [next_cost, next_state]
		end
	end
end

# solve
p bestroute(data, false)
p bestroute(data, true)

#  17   00:49:08   1255      0   00:57:51   1059      0
# 861
# 1032 bad missed min 4 steps acceptance condition
# 1037
