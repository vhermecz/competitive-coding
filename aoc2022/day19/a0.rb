require 'set'

#INPUT='test'
INPUT='input'

MINERALS = [:ore, :clay, :obsidian, :geode]
ORE = 0
CLAY = 1
OBSIDIAN = 2
GEODE = 3

# read_input
data = File.read(INPUT).split("\n").each_with_index.map do |bp, idx|
	robots = bp.split(":").last.split(".").map{|v|v.split(" costs ").last}.map do |robot|
		robot.split(" and ").map do |mineral|
			mineral.split(" ").then do |amt, name|
				[name.to_sym, amt.to_i]
			end
		end.to_h
	end.map do |robot|
		MINERALS.map do |mineral|
			robot[mineral] || 0
		end
	end
	{
		:idx => idx,
		:costs => robots
	}
end

def possible_builds(minerals, robots, robot_costs, maxes)
	# opt1: dont build if already have enough
	res = 4.times.filter{|x|vec_le(robot_costs[x], minerals) && robots[x] < maxes[x]} + [nil]
end

def vec_le(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1<=vv2}.all?
end

def vec_sub(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1-vv2}
end

def vec_add(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1+vv2}
end

def pruner(states)
	td = Time.now.to_f
	states = states.group_by{|x|x.last}.values.map do |states|
		states.filter do |state1|
			not states.any? do |state2|
				state1 != state2 && vec_le(state1.first, state2.first)
			end
		end
	end.flatten(1)
	states = states.group_by{|x|x.first}.values.map do |states|
		states.filter do |state1|
			not states.any? do |state2|
				state1 != state2 && vec_le(state1.last, state2.last)
			end
		end
	end.flatten(1)
	$tp += Time.now.to_f - td
	states
end

def solver(robot_costs, time)
	$tp = 0
	$ts = 0
	maxes = robot_costs.first.zip(*robot_costs[1..]).map(&:max)
	maxes[GEODE] = 1337
	state = Set.new [[[0,0,0,0], [1,0,0,0]]]
	time.times do |tim|
		td = Time.now.to_f
		nstate = Set.new
		state.each do |minerals, robots|
			possible_builds(minerals, robots, robot_costs, maxes).map do |build|
				# spend
				nminerals = minerals
				nminerals = vec_sub(nminerals, robot_costs[build]) unless build.nil?
				# collect
				nminerals = vec_add(nminerals, robots)
				nminerals = nminerals.each_with_index.map{|v,i|robots[i]>=maxes[i] ? maxes[i]:v}  # opt3: dont care about wealth
				# build
				nrobots = robots[0..]
				nrobots[build] += 1 unless build.nil?
				nstate << [nminerals, nrobots]
			end
		end
		$ts += Time.now.to_f - td
		nstate = pruner(nstate) unless tim+1==time  # opt2: remove suboptimal states
		state = nstate
		p [tim+1, state.map{|v|v.first.last}.max, state.length, $tp, $ts]
	end
	state.map{|v|v.first.last}.max
end

p data.each_with_index.map{|conf,idx|(idx+1)*solver(conf[:costs], 24)}.sum
p data[0..2].each.map{|conf|solver(conf[:costs], 32)}.inject(&:*)

# 1418 too low
# fsck: realized can build one robot at a time
# 08:13:11 1550 4136
# 18285 (too-low, manual cuts)
# 09:07:17 18630 3526 
