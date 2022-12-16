require 'set'

#INPUT='test'
INPUT='input'

# read_input
grid = File.read(INPUT).split("\n").map do |row|
	row = row.split(" ")
	[row[1], [row[4].split("=").last.to_i, row[9..].map{|i|i[..1]}]]
end.to_h


def solve(grid, init, tend)
	all_real_valve = Set.new grid.filter{|k,v|v[0]>0}.map{|k,v|k}
	valvemap = all_real_valve.each_with_index.map{|pos, idx|[pos, 2**idx]}.to_h
	curr = { [init, 0] => 0 }
	time = 1
	while time < tend
		td = Time.now.to_f
		nxt = {}
		curr.each do |state, score|
			pos, opened = state
			steps = pos.map do |current|
				steps = grid[current][1][0..]
				steps << current if (grid[current][0] > 0) && ((opened & valvemap[current]) == 0)
				steps
			end
			steps = steps.first.product(*steps[1..])
			steps.each do |npos|
				nopened = opened
				nscore = pos.zip(npos).map do |p, np|
					if (p==np) && (!valvemap[p].nil?) && ((nopened & valvemap[p]) == 0)
						nopened += valvemap[p]
						(tend-time)*grid[p][0] 
					else
						0
					end
				end.sum
				nxt[[npos, nopened]] = [nxt[[npos, nopened]] || 0, score+nscore].max
			end
		end
		curr = nxt
		time += 1
		p [time, curr.values.max, curr.length, Time.now.to_f - td]
	end
	curr.values.max
end

p solve(grid, ["AA"], 30)
p solve(grid, ["AA", "AA"], 26)
