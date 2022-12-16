require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.split(" ")
	[row[1], [row[4].split("=").last.to_i, row[9..].map{|i|i[..1]}]]
end.to_h

$cache = {}

def maxer(grid, current, opened, openflow, time)
	cached = $cache[[current, opened, openflow, time]]
	return cached if not cached.nil?
	score = openflow
	return openflow if time == 30
	# open
	if grid[current][0] > 0 and not opened.include? current
		opened.add(current)
		score += maxer(grid, current, opened, openflow + grid[current][0], time+1)
		opened.delete(current)
	end
	# move
	bestmove = grid[current][1].map do |next_|
		maxer(grid, next_, opened, openflow, time+1)
	end.max
	res = [score, openflow + bestmove].max
	$cache[[current, opened, openflow, time]] = res
end

# solve
p maxer(data, "AA", Set.new, 0, 1)

# 00:19:28 2056 52 (solved by a1.py)
# 06:31:18 2513 2529 (solved by a0.py)
