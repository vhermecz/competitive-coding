require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |r|
	r.split(" -> ").map{|c|c.split(",").map(&:to_i)}
end
sand = [500, 0]

def draw(data)
	grid = Set.new
	data.each do |path|
		path.each_cons(2) do |a, b|
			delta = b.zip(a).map{|bv,av|bv-av}
			steps = delta.map(&:abs).max
			(steps+1).times do |step|
				pos = a.zip(delta).map{|av,dv|av+dv*step/steps}
				grid.add(pos)
			end
		end
	end
	grid
end

def drop(grid, pos, h, infiniplane:false)
	while true do
		return false if grid.include? pos
		if pos[1] == h+1 and infiniplane
			grid.add pos
			return true
		end
		return false if pos[1] > h+1
		posd = [pos[0], pos[1]+1]
		if not grid.include? posd
			pos = posd
			next
		end
		posdl = [pos[0]-1, pos[1]+1]
		if not grid.include? posdl
			pos = posdl
			next
		end
		posdr = [pos[0]+1, pos[1]+1]
		if not grid.include? posdr
			pos = posdr
			next
		end
		grid.add pos
		return true
	end
end

def solve(data, sand, infiniplane:false)
	grid = draw(data)
	h = grid.each.map(&:last).max
	cnt = 0
	while drop(grid, sand, h, infiniplane:infiniplane)
		cnt += 1
	end
	cnt
end

p solve(data, sand, infiniplane:false)
p solve(data, sand, infiniplane:true)

# reimplement
# part1 11min
# part2 14min
# cleanp 19min
# runtime is 9.7s instead of 0.7s