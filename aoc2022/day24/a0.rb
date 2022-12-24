require 'rb_heap'
require 'set'

#INPUT='test'
INPUT='input'

STORM_DIRS = {
	"<": [-1, 0],
	">": [1, 0],
	"v": [0, 1],
	"^": [0, -1],
}

DIRS = STORM_DIRS.values + [[0, 0]]

w = 0
h = 0
# read_input
data = File.read(INPUT).split("\n").each_with_index.map do |r,y|
	r.split("").each_with_index.map do |c,x|
		w = [x-1,w].max
		h = [y-1,h].max
		[c, [x-1, y-1]] if ["<", ">", "^", "v"].include? c
	end
end.flatten(1).compact

W=w
H=h

p [W, H]

fixwalls = []
fixwalls += (1..W).map{|v|[v,-1]}
fixwalls += (-1..W-2).map{|v|[v,H]}
fixwalls += (-1..H).map{|v|[-1,v]}
fixwalls += (-1..H).map{|v|[W,v]}
fixwalls << [0, -2]
fixwalls << [W-1, H+1]
FIXWALLS = fixwalls

WALLS_T = {}
def walls(data, t)
	WALLS_T[t] ||= (data.map do |d, pos|
		dpos = STORM_DIRS[d.to_sym]
		[
			(pos.first + dpos.first * t) % W,
			(pos.last + dpos.last * t) % H,
		]
	end + FIXWALLS).to_set
end

def solve(data, start_t, start_pos, end_pos)
	visited = Hash.new
	expand = Heap.new{|a, b| a[0] < b[0]}
	expand.add [start_t, start_pos]
	while !expand.empty? do
		t, pos = expand.pop
		break if pos == end_pos
		next if visited[[t, pos]]
		wallst = walls(data, t+1)
		visited[[t,pos]] = t
		DIRS.each do |dx,dy|
			x, y = pos
			nx, ny = x+dx, y+dy
			npos = [nx, ny]
			next if wallst.include? npos
			expand.add [t+1, npos]
		end
	end
	t
end

t_first = solve(data, 0, [0,-1], [W-1, H])
p t_first
t_sec = solve(data, t_first, [W-1, H], [0,-1])
#p t_sec
t_third = solve(data, t_sec, [0,-1], [W-1, H])
p t_third

# 39:44 373 518
# 42:56 997 413
