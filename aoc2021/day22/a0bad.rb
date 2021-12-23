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
	p [cube1, cube2, dim]
	return [nil, [], [cube2]] if cube2[dim].first >= cube1[dim].last
	return [nil, [], [cube2]] if cube1[dim].first >= cube2[dim].last
	c1only = []
	common = []
	c1c = []
	c2c = []
	c2only = []
	cube1, cube2, c1only, c2only, c1c, c2c = cube2, cube1, c2only, c1only, c2c, c1c if cube1[dim].first > cube2[dim].first
	# cube1 smaller
	# first
	cube = deepcopy(cube1)
	cube[dim] = [cube1[dim].first, cube2[dim].first]
	c1only << cube if cube[dim].last-cube[dim].first
	# intersect
	cube1c = deepcopy(cube1)
	cube1c[dim] = [cube2[dim].first, [cube1[dim].last, cube2[dim].last].min]
	c1c << cube1c
	cube2c = deepcopy(cube2)
	cube2c[dim] = [cube2[dim].first, [cube1[dim].last, cube2[dim].last].min]
	c2c << cube2c
	common << [c1c, c2c] if cube1c[dim].last-cube1c[dim].first
	# last
	isc2last = (cube1[dim].last<=cube2[dim].last)
	cube = deepcopy([cube1, cube2][isc2last ?1:0])
	cube[dim] = [[cube1[dim].last, cube2[dim].last].min, [cube1[dim].last, cube2[dim].last].max]
	[c1only, c2only][isc2last ? 1:0] << cube if cube[dim].last-cube[dim].first
	return [common, c1only, c2only]
end


["upcut-in", [[10, 12], [10, 12], [10, 12]], [[11, 13], [11, 13], [11, 13]]]

["upcut-res", 0, [[[[[11, 12], [10, 12], [10, 12]]], [[[11, 12], [11, 13], [11, 13]]]]], [[[10, 11], [10, 12], [10, 12]]], [[[12, 13], [11, 13], [11, 13]]]]
["upcut-in", [[[[11, 12], [10, 12], [10, 12]]], [[[11, 12], [11, 13], [11, 13]]]], nil]


# [list-intersect, list-cube1-only, list-cube2-only]
def upcut cube1, cube2
	c1only = []
	c2only = []
	3.times do |dim|
		p ["upcut-in", cube1, cube2]
		overlap, dimc1, dimc2 = upcutdim(cube1, cube2, dim)
		p ["upcut-res", dim, overlap, dimc1, dimc2]
		c1only += dimc1
		c2only += dimc2
		break if overlap.empty?
		cube1, cube2 = overlap
	end
	[overlap.first, c1only, c2only] 
end

p data

state = []
data.each do |(switch, cube)|
	nstate = []
	cubes = [cube]
	state.each do |bcube|
		ncubes = []
		cubes.each do |cube|
			overlap, onlybase, onlynew = upcut bcube, cube
			nstate += onlybase
			nstate << overlap if switch
			ncubes += onlynew
		end
		cubes = ncubes
	end
	nstate += cubes if switch
	state = nstate
end

p state.map{|cube|cube.map{|dim|dim.last-dim.first}.reduce(:*)}.sum




p data
# solve
