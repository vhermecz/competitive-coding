require 'set'

INPUT='test'
#INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	state, size = row.strip.split(" ")
	[
		state == "on",
		size.split(",").map{|dim|dim.split("=").map{|mm|mm.split("..").map(&:to_i)}.last},
	]
end

def deepcopy(a)
	Marshal.load(Marshal.dump(a))
end

# [list-intersect, list-cube1-only, list-cube2-only]
def upcutdim(cube1, cube2, dim)
	#p [cube1, cube2, dim]
	return [nil, [cube1], [cube2]] if cube2[dim].first >= cube1[dim].last || cube1[dim].first >= cube2[dim].last
	#return [nil, [deepcopy(cube1)], [deepcopy(cube2)]] if cube2[dim].first >= cube1[dim].last || cube1[dim].first >= cube2[dim].last
	c1only = []
	c2only = []
	only = [c1only, c2only]
	c1c = []
	c2c = []
	common = [c1c, c2c]
	cube1, cube2, c1only, c2only, c1c, c2c = cube2, cube1, c2only, c1only, c2c, c1c if cube1[dim].first > cube2[dim].first
	# 
	# 
	# cube1 smaller
	# first
	cube = deepcopy(cube1)
	cube[dim] = [cube1[dim].first, cube2[dim].first]
	c1only << cube if cube[dim].last-cube[dim].first>0
	# intersect
	cube1c = deepcopy(cube1)
	cube1c[dim] = [cube2[dim].first, [cube1[dim].last, cube2[dim].last].min]
	c1c << cube1c
	cube2c = deepcopy(cube2)
	cube2c[dim] = [cube2[dim].first, [cube1[dim].last, cube2[dim].last].min]
	c2c << cube2c
	common = common.map(&:first)
	common = nil if cube1c[dim].last-cube1c[dim].first<=0
	# last
	isc2last = (cube1[dim].last<=cube2[dim].last)
	cube = deepcopy([cube1, cube2][isc2last ?1:0])
	cube[dim] = [[cube1[dim].last, cube2[dim].last].min, [cube1[dim].last, cube2[dim].last].max]
	[c1only, c2only][isc2last ? 1:0] << cube if cube[dim].last-cube[dim].first>0
	return [common] + only
end

def manipul cube, v
	cube.map{|(lo,hi)|[lo,hi+v]}
end

def manipulall cubes, v
	cubes.map{|cube|manipul(cube, v)}
end


# [list-intersect, list-cube1-only, list-cube2-only]
def upcut cube1, cube2
	cube1 = manipul(cube1, 1)
	cube2 = manipul(cube2, 1)
	c1only = []
	c2only = []
	overlap = []
	3.times do |dim|
		#p ["upcut-in", cube1, cube2, dim]
		overlap, dimc1, dimc2 = upcutdim(cube1, cube2, dim)
		#p ["upcut-res", overlap, dimc1, dimc2]
		c1only += dimc1
		c2only += dimc2
		break if overlap.nil?
		cube1, cube2 = overlap
	end
	[(manipulall(overlap||[], -1)).first, manipulall(c1only, -1), manipulall(c2only, -1)] 
end

def points(cube)
	cube.map do |dim|
		Range.new(*dim).to_a.map{|v|[v]}
	end.reduce do |acc, v|
		acc.product(v).map(&:flatten)
	end.then{|v|Set.new v}
end

def validate(cube1, cube2, overlap, c1o, c2o)
	c1p = points(cube1)
	c2p = points(cube2)
	return "missing-overlap" if (c1p&c2p) != points(overlap||[])
	c1v = points(overlap||[]).length
	c1o.each do |c1c|
		c1cp = points(c1c)
		c1v += c1cp.length
		return "c1o in c2" unless (c2p&c1cp).empty?
		return "c1o out c1" unless (c1cp-c1p).empty?
	end
	return "overlapping c1os" if c1v != c1p.length
	c2v = points(overlap||[]).length
	c2o.each do |c2c|
		c2cp = points(c2c)
		c2v += c2cp.length
		return "c2o in c1" unless (c1p&c2cp).empty?
		return "c2o out c2" unless (c2cp-c2p).empty?
	end
	return "overlapping c1os" if c2v != c2p.length
	return nil
end

def volume(state)
	state.map{|cube|cube.map{|dim|dim.last-dim.first+1}.reduce(:*)}.sum
end

 # c1 = [[10, 10], [10, 12], [10, 12]]
 # c2 = [[9, 11], [9, 11], [9, 11]]
 # res = upcut(c1,c2)
 # p res
 # valid

 def megbasz(cubes1, cubes2)
 	overlaps = Set.new
 	changed = true
 	while changed
 		changed = false
	 	cubes1.to_a.product(cubes2.to_a).each do |cube1, cube2|
	 		overlap, only1, only2 = upcut cube1, cube2
	 		same = (only1 == [cube1] && only2 == [cube2])
	 		#p [!overlap.nil?, only1.length, only2.length, same]
	 		overlaps << overlap if !overlap.nil?
	 		if !same
	 			cubes1.delete(cube1)
	 			cubes1.merge(only1)
	 			cubes2.delete(cube2)
	 			cubes2.merge(only2)
	 			changed = true
	 			break
	 		end
	 	end
	end
 	overlaps
 end

state = Set.new
data.each do |(switch, cube)|
	#switch = true
	p [volume(state), state.length, switch, cube]
	cubes = Set[cube]
	overlap = megbasz(state, cubes)
	#p ["meg", state]
	p [cubes.length, overlap.length]
	state += cubes if switch
	state -= overlap if !switch
	#p state
end

p [volume(state), state.length]

# 10:50 gave up