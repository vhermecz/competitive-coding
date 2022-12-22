require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").then do |maze, move|
	move = move.strip.split("L").map { |x| [x, 'L'] }.flatten[0...-1]
	move = move.map do |smove|
		smove.split("R").map { |x| [x, 'R'] }.flatten[0...-1]
	end.flatten
	maze = maze.split("\n").map{|r|r.split("")}
	w = maze.map{|r|r.length}.max
	maze = maze.map do |r|
		r + [" "] * (w-r.length)
	end
	[maze, move]
end

def rot_r(dir)
	[1, 0]
	[0, 1]
	[-1, 0]
	[-dir.last, dir.first]
end

def rot_l(dir)
	[dir.last, -dir.first]
end

def wrap1(pos, dir)
	npos = pos
	while true do
		npos = step(npos,dir)
		break if MAZE[npos.last][npos.first] != " "
	end
	[npos, dir]
end

def wrap2(pos, dir)
	side = H/4
	m = side-1
	x=42
	cpos = [pos.first/side, pos.last/side]
	cipos =[pos.first%side, pos.last%side]
	rot_rules = [
		[[[1,0], DIR_T], [ 1, [0,3], x,   -> (x,y) { [y  , 0] }, DIR_R]], # 0,x
		[[[2,0], DIR_T], [ 2, [0,3], 0,   -> (x,y) { [m  , y] }, DIR_T]], # x,m
		[[[2,0], DIR_R], [ 3, [1,2], 180, -> (x,y) { [m-x, m] }, DIR_L]], # m,m-y
		[[[2,0], DIR_D], [ 4, [1,1], -90, -> (x,y) { [y  , m] }, DIR_L]], # m,x
		[[[1,1], DIR_R], [ 5, [2,0], 90 , -> (x,y) { [m  , x] }, DIR_T]], # y,m
		[[[1,2], DIR_R], [ 6, [2,0], 180, -> (x,y) { [m-x, m] }, DIR_L]], # m,m-y
		[[[1,2], DIR_D], [ 7, [0,3], 90,  -> (x,y) { [y  , m] }, DIR_L]], # m,x
		[[[0,3], DIR_R], [ 8, [1,2], -90, -> (x,y) { [m  , x] }, DIR_T]], # y,m
		[[[0,3], DIR_D], [ 9, [2,0], 0,   -> (x,y) { [0  , y] }, DIR_D]], # x,0
		[[[0,3], DIR_L], [10, [1,0], x,   -> (x,y) { [0  , x] }, DIR_D]], # y,0
		[[[0,2], DIR_L], [11, [1,0], 180, -> (x,y) { [m-x, 0] }, DIR_R]], # 0,m-y
		[[[0,2], DIR_T], [12, [1,1], -90, -> (x,y) { [y  , 0] }, DIR_R]], # 0,x
		[[[1,1], DIR_L], [13, [0,2], x,   -> (x,y) { [0  , x] }, DIR_D]], # y,0
		[[[1,0], DIR_L], [14, [0,2], 180, -> (x,y) { [m-x, 0] }, DIR_R]], # 0,m-y
	].to_h
	idx, ncpos, deg, tf, ndir = rot_rules[[cpos, dir]]
	p ["WRAP", idx]
	ncipos = tf.call(*cipos.reverse).reverse
	#ncipos = [ncipos.first % (H/4), ncipos.last % (W/3)]
	npos = [ncpos.first*side + ncipos.first, ncpos.last*side + ncipos.last]
	[npos, ndir]
end

def step(pos, dir)
	[(pos.first+dir.first) % W, (pos.last+dir.last) % H]
end

DIR_R = [1, 0]
DIR_L = [-1, 0]
DIR_T = [0, -1]
DIR_D = [0, 1]

MAZE, MOVE = data
W = MAZE.first.length
H = MAZE.length

pos = [MAZE[0].index("."), 0]
dir = DIR_R

p ["", pos, dir]
MOVE.each do |rule|
	#p rule
	if rule == "R"
		dir = rot_r(dir)
	elsif rule == "L"
		dir = rot_l(dir)
	else
		rule.to_i.times do
			npos = step(pos, dir)
			ndir = dir
			npos, ndir = wrap2(pos, dir) if MAZE[npos.last][npos.first] == " "
			break if MAZE[npos.last][npos.first] == "#"
			pos = npos
			dir = ndir
		end
	end
	#p [rule, pos, dir]
end

denc = 0
while dir != DIR_R
	dir = rot_l(dir)
	denc += 1
end

v = (pos.last+1) * 1000 + 4*(pos.first+1) + denc
p v
p pos, dir

# solve
# 31:50 149250 427
# 18412 too high (bug: x-y swap in tf)
# 41500 too high (bug: ignoring ncpos, using npos)
# 14383 too high (bug: dir still changes when # after wrap)
# 2:31:44 12462 898 (specialized for input)
# part2 no generic solution
