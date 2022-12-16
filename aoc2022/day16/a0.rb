require 'set'

#INPUT='test'
INPUT='input'

# read_input
grid = File.read(INPUT).split("\n").map do |row|
	row = row.split(" ")
	[row[1], [row[4].split("=").last.to_i, row[9..].map{|i|i[..1]}]]
end.to_h

all_real_valve = Set.new grid.filter{|k,v|v[0]>0}.map{|k,v|k}
$valvemap = all_real_valve.each_with_index.map{|pos, idx|[pos, 2**idx]}.to_h
$node_map = grid.keys.each_with_index.to_h
$init = ["AA", "AA"]

$pos_map = grid.keys.product(*[grid.keys]*($init.length-1)).map do |pos|
	[pos, pos.each_with_index.map{|v, idx|$node_map[v]*$node_map.length**idx}.sum]
end.to_h
$pos_map_inv = $pos_map.invert

def encode(state)
	$pos_map[state.first] * 2**$valvemap.length + state.last	
end

def decode(state)
	opened = state % 2**$valvemap.length
	state /= 2**$valvemap.length
	[$pos_map_inv[state], opened]
end

$tend = 26
$statesize = 2**$valvemap.length * grid.length**$init.length
curr = [nil] * $statesize
curr[encode([$init, 0])] = 0
p [$statesize, $valvemap, grid.length, $init.length]
time = 1
while time < $tend
	td = Time.now.to_f
	nxt = [nil] * $statesize
	max_now = curr.compact.max
	best = (2**$valvemap.length).times.map do |opened|
		$valvemap.map do |pos, mask|
			($tend-time)*grid[pos][0] if opened & mask == 0
		end.compact.sum
	end
	curr.each_with_index do |score, state_code|
		next if score.nil?
		pos, opened = decode(state_code)
		next if score + best[opened] <= max_now 
		steps = pos.map do |current|
			steps = grid[current][1][0..]
			steps << current if (grid[current][0] > 0) && ((opened & $valvemap[current]) == 0)
			steps
		end
		steps = steps.first.product(*steps[1..])
		steps.each do |npos|
			nopened = opened
			nscore = pos.zip(npos).map do |p, np|
				if (p==np) && (!$valvemap[p].nil?) && ((nopened & $valvemap[p]) == 0)
					nopened += $valvemap[p]
					($tend-time)*grid[p][0] 
				else
					0
				end
			end.sum
			nstate_code = encode([npos, nopened])
			nxt[nstate_code] = [nxt[nstate_code] || 0, score+nscore].max
		end
	end
	curr = nxt
	time += 1
	p [time, curr.compact.max, curr.compact.length, Time.now.to_f - td]
end
