require 'set'

INPUT='test3'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n")

n_row = data.length
n_col = data.first.length

# FIXME
if INPUT=='test'
	start_pos = [2, 0]
	start_field = 'F'
elsif INPUT=='test3'
	start_pos = [1, 1]
	start_field = 'F'
elsif INPUT=='test2'
	start_pos = [4, 12]
	start_field = 'F'
else
	start_pos = [42, 25]
	start_field = '7'
end	
data[start_pos.first][start_pos.last] = start_field


field = data.map{|row|row.dup}


D_NORTH = [-1, 0]
D_SOUTH = [1, 0]
D_WEST = [0, -1]
D_EAST = [0, 1]

D_CONNS = {
	'|': [D_NORTH, D_SOUTH],
	'-': [D_EAST, D_WEST],
	'L': [D_NORTH, D_EAST],
	'J': [D_NORTH, D_WEST],
	'7': [D_SOUTH, D_WEST],
	'F': [D_SOUTH, D_EAST],
}

seen = Set.new
expand = [[start_pos, 0]]
max_dist = 0
while expand.length > 0
	curr_pos, curr_dist = expand.shift
	max_dist = [max_dist, curr_dist].max
	next if data[curr_pos.first][curr_pos.last] == 'X'
	D_CONNS[data[curr_pos.first][curr_pos.last].to_sym].each do |d_pos|
		next_pos = [curr_pos.first + d_pos.first, curr_pos.last + d_pos.last]
		# NO NEED boundary check, closed loop
		next if data[next_pos.first][next_pos.last] == 'X'
		data[curr_pos.first][curr_pos.last] = 'X'
		expand << [next_pos,curr_dist+1]
	end
	data[curr_pos.first][curr_pos.last] = 'X'
end
# solve
p max_dist

data2 = data.each.map do |row|
	#p row
	row.split("").map do |cell|
		if cell == 'X'
			'X'
		else
			' '
		end
	end.join("")
end

expand = []
(0..n_row*2-2).each do |r|
	expand << [r, 0]
	expand << [r, n_col*2-2]
end
(0..n_col*2-2).each do |c|
	expand << [0, c]
	expand << [n_row*2-2, c]
end

seen = Set.new
while expand.length > 0
	curr_pos = expand.pop
	next if seen.include? curr_pos
	seen << curr_pos
	if curr_pos.first % 2 == 0 && curr_pos.last % 2 == 0
		next if data2[curr_pos.first/2][curr_pos.last/2] != ' '
		data2[curr_pos.first/2][curr_pos.last/2] = '.'
	else
		conns = D_CONNS[field[curr_pos.first/2][curr_pos.last/2].to_sym]
		is_loop = data2[curr_pos.first/2][curr_pos.last/2] == 'X'
		if !is_loop || curr_pos.first % 2 == 1 && curr_pos.last % 2 == 1
			# noop
		elsif curr_pos.first % 2 == 1 && conns.include?(D_SOUTH)
			next
		elsif curr_pos.last % 2 == 1 && conns.include?(D_EAST)
			next
		end
	end
	[D_NORTH, D_WEST, D_EAST, D_SOUTH].each do |d_pos|
		next_pos = [curr_pos.first + d_pos.first, curr_pos.last + d_pos.last]
		next if next_pos.first < 0 || next_pos.first >= n_row*2-1
		next if next_pos.last < 0 || next_pos.last >= n_col*2-1
		expand << next_pos
	end
end

fillcnt = 0
data2.each do |row|
	#p row
	row.split("").each do |col|
		if col == ' '
			fillcnt +=1 
		end
	end
end

p fillcnt

# 10   00:24:49    897      0   01:43:48   1992      0
# 7173
# star2 attempts:
#   611 bad @44:30 ouch
#   @67:14 garbage
#   14 bad
#   3 bad
#   0 bad 5 min penalty (desperate)
# 291
