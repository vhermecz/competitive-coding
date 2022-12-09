require 'set'

#INPUT='test2'
INPUT='input'

data = File.read(INPUT).split("\n").map do |r|
	dir, step = r.split(" ")
	[dir, step.to_i]
end

DIRS = {
	"L" => [-1, 0],
	"R" => [1, 0],
	"U" => [0, -1],
	"D" => [0, 1],
}

def move(pos, dir)
	[pos[0]+dir[0], pos[1]+dir[1]]
end

def delta(pos1, pos2)
	[pos1[0]-pos2[0], pos1[1]-pos2[1]]
end

def clamp(delta)
	[delta[0].clamp(-1,1), delta[1].clamp(-1,1)]
end

def dist(pos1, pos2)
	d = delta(pos1, pos2)
	(d[0]**2 +d[1]**2)**0.5
end

# solve
rope = 10.times.map{[0, 0]}
t_poss1 = [rope[1]].to_set
t_poss2 = [rope[9]].to_set
data.each do |dir, step|
  step.times do
  	idx = 0
  	update = true
	rope[idx] = move(rope[idx], DIRS[dir])
  	while update do
  		break if idx == 9
  		if dist(rope[idx], rope[idx+1]) > 1.5
	  		rope[idx+1] = move(rope[idx+1], clamp(delta(rope[idx], rope[idx+1])))
	  	else
	  		update = false
	  	end
	  	idx += 1
	end
  	t_poss1.add(rope[1])
  	t_poss2.add(rope[-1])
  end
end

p t_poss1.length
p t_poss2.length

# 00:17:00 6271 1318
# 00:22:50 2458 655
