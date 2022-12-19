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

def possible_builds(minerals, robot_costs)
	maxes = [
		minerals[ORE] / robot_costs[ORE][ORE],
		minerals[ORE] / robot_costs[CLAY][ORE],
		[
			minerals[CLAY] / robot_costs[OBSIDIAN][CLAY],
			minerals[ORE] / robot_costs[OBSIDIAN][ORE],
		].min,
		[
			minerals[OBSIDIAN] / robot_costs[GEODE][OBSIDIAN],
			minerals[ORE] / robot_costs[GEODE][ORE],
		].min,
	]
	ranges = maxes.map do |mx|
		(0..mx).to_a
	end
	combos = ranges.first.product(*ranges[1..])
	# prune bads
	combos = combos.filter do |counts|
		cost = calc_costs(counts, robot_costs)
		vec_le(cost, minerals)
	end
	#p combos.length
	combos
end

def possible_builds_greedy(minerals, robot_costs)
	geode = [
		minerals[OBSIDIAN] / robot_costs[GEODE][OBSIDIAN],
		minerals[ORE] / robot_costs[GEODE][ORE],
	].min
	minerals = vec_sub(minerals, vec_mulscal(robot_costs[GEODE], geode))
	obsidian = [
		minerals[CLAY] / robot_costs[OBSIDIAN][CLAY],
		minerals[ORE] / robot_costs[OBSIDIAN][ORE],
	].min
	minerals = vec_sub(minerals, vec_mulscal(robot_costs[OBSIDIAN], obsidian))
	clay = minerals[ORE] / robot_costs[CLAY][ORE]
	minerals = vec_sub(minerals, vec_mulscal(robot_costs[clay], clay))
	ore = minerals[ORE] / robot_costs[ORE][ORE]
	res = [[ore, clay, obsidian, geode]]
	#p res
	res
end


def possible_builds_semigreedy(minerals, robot_costs)
	ominerals = minerals
	geode = [
		minerals[OBSIDIAN] / robot_costs[GEODE][OBSIDIAN],
		minerals[ORE] / robot_costs[GEODE][ORE],
	].min
	minerals = vec_sub(minerals, vec_mulscal(robot_costs[GEODE], geode))
	obsidian = [
		minerals[CLAY] / robot_costs[OBSIDIAN][CLAY],
		minerals[ORE] / robot_costs[OBSIDIAN][ORE],
	].min
	minerals = vec_sub(minerals, vec_mulscal(robot_costs[OBSIDIAN], obsidian))
	clay = minerals[ORE] / robot_costs[CLAY][ORE]
	ore = minerals[ORE] / robot_costs[ORE][ORE]
	ranges = [(0..ore).to_a, (0..clay).to_a, [obsidian], [geode]]
	combos = ranges.first.product(*ranges[1..])
	# prune bads
	ncombos = combos.filter do |counts|
		cost = calc_costs(counts, robot_costs)
		vec_le(cost, ominerals)
	end
	ncombos
end


def possible_builds_semigreedy_fixed(minerals, robot_costs)
	combos = [
		[0,0,0,0],
		[1,0,0,0],
		[0,1,0,0],
		[0,0,1,0],
		[0,0,0,1],
	]
	ncombos = combos.filter do |counts|
		cost = calc_costs(counts, robot_costs)
		vec_le(cost, minerals)
	end
	ncombos	
end


def vec_le(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1<=vv2}.all?
end

def vec_mulscal(v1, s)
	v1.map{|vv1|vv1*s}
end

def vec_sub(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1-vv2}
end

def vec_add(v1, v2)
	v1.zip(v2).map{|vv1,vv2|vv1+vv2}
end

$ccc = {}
def calc_costs(robot_counts, robot_costs)
	c = $ccc[robot_counts]
	return c unless c.nil?
	res = [0] * 4
	robot_counts.zip(robot_costs).each do |count, robot_cost|
		robot_cost.each_with_index do |cost, mineral|
			res[mineral] += cost * count
		end
	end
	$ccc[robot_counts] = res
end

$cnt = 0

def solver(minerals, robots, robot_costs, time)
	$cnt += 1
	return minerals[GEODE] if time == 15
	# possible spends
	possible_builds(minerals, robot_costs).map do |build|
		# spend
		nminerals = vec_sub(minerals, calc_costs(build, robot_costs))
		# collect
		nminerals = vec_add(nminerals, robots)
		# build
		nrobots = vec_add(robots, build)
		solver(nminerals, nrobots, robot_costs, time+1)
	end.max
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


def solver2(robot_costs, time)
	$ccc = {}
	$tp = 0
	$ts = 0
	# robot_costs.each do |r|
	# 	p r
	# end
	maxes = robot_costs.first.zip(*robot_costs[1..]).map(&:max)
	#print maxes
	max_ore = robot_costs.map(&:first).max
	# p ["maxore", max_ore]
	state = Set.new [[[0,0,0,0], [1,0,0,0]]]
	#path = {}
	time.times do |tim|
		td = Time.now.to_f
		nstate = Set.new
		state.each do |minerals, robots|
			possible_builds_semigreedy_fixed(minerals, robot_costs).map do |build|
				# $cnt += 1
				# spend
				next if build[ORE] > 0 && robots[ORE] >= maxes[ORE]
				next if build[CLAY] > 0 && robots[CLAY] >= maxes[CLAY]
				next if build[OBSIDIAN] > 0 && robots[OBSIDIAN] >= maxes[OBSIDIAN]
				#next if build[ORE] > 0 && tim+1 > 15
				#next if build[CLAY] > 0 && tim+1 > 22
				#next if build[OBSIDIAN] > 0 && tim+1 > 27
				nminerals = vec_sub(minerals, calc_costs(build, robot_costs))
				#next if nminerals[ORE] >= max_ore * 3
				#next if nminerals[CLAY] >= maxes[CLAY] *3
				#next if nminerals[OBSIDIAN] >= maxes[OBSIDIAN] *3
				# collect
				nminerals = vec_add(nminerals, robots)
				nminerals[ORE] = maxes[ORE] if robots[ORE] >= maxes[ORE]
				nminerals[CLAY] = maxes[CLAY] if robots[CLAY] >= maxes[CLAY]
				nminerals[OBSIDIAN] = maxes[OBSIDIAN] if robots[OBSIDIAN] >= maxes[OBSIDIAN]
				# build
				nrobots = vec_add(robots, build)
				nstate << [nminerals, nrobots]
				#path[[nminerals, nrobots, tim+1]] = [minerals, robots, tim]
			end
		end
		state = nstate
		$ts += Time.now.to_f - td
		preprune = state.length
		state = pruner(state) unless tim+1==time
		#File.write("dump", state)
		max_geode = state.map{|x|x.last.last}.max
		# state = state.filter{|x|x.last.last == max_geode}
		#p state.map{|v|v.first.first}.tally
		#p state.map{|v|v.last.first}.tally
		#p [tim+1, state.length, state.map{|v|v.first.last}.max, Time.now.to_f - td]
		#p [tim+1, state.map{|v|v.first.last}.max, preprune, state.length, $tp, $ts]
	end
	#track = state.first + [time]
	#while not track.nil?
    #	#p [track]
	#	track = path[track]
	#end
	state.map{|v|v.first.last}.max
end

# 1: 4 0 0 0
# 0: 2 0 0 0
# 2: 3 14 0 0
# 0: 2 0 7 0

#p data
# solve
#p solver([0,0,0,0], [1,0,0,0], data[0][:costs], 0)
#p solver2(data[0][:costs], 25)
#p $cnt

p data.each_with_index.map{|conf,idx|(idx+1)*solver2(conf[:costs], 24)}.sum
p data[0..2].each.map{|conf|solver2(conf[:costs], 32)}.inject(&:*)

# 12 3115
# 13 10100
# 14 39826
# 15 184719
# 16 1075211


# fuck: realized can build one robot at a time
# 1418 too low
# 1550 (cuting for max_ore * 3 limit)