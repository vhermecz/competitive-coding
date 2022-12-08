require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map{|x|x.split("").map(&:to_i)}

def stepper(pos, dir)
	[pos[0]+dir[0], pos[1]+dir[1]]
end

def scan1(data, visible, pos, dir)
	curr_h = -1
	while true do
		return if pos[0] < 0 or pos[1] < 0
		return if data[pos[1]].nil? or data[pos[1]][pos[0]].nil?
		curr_h_pos = data[pos[1]][pos[0]]
		pre_vis = visible[pos[1]][pos[0]]
		if curr_h_pos > curr_h
			visible[pos[1]][pos[0]] = 1 
			curr_h = curr_h_pos
		end
		pos = stepper(pos, dir)
	end
end

def solve1(data)
	h = data.length
	w = data.first.length
	visible = h.times.map do
		[0] * w
	end
	h.times do |y|
		scan1(data, visible, [0,y], [1, 0])
		scan1(data, visible, [w-1,y], [-1, 0])
	end
	w.times do |x|
		scan1(data, visible, [x,0], [0, 1])
		scan1(data, visible, [x,h-1], [0, -1])
	end
	visible.flatten.sum
end

def scan2(data, pos, dir)
	curr = data[pos[1]][pos[0]]
	cnt = 0
	pos = stepper(pos, dir)
	while pos[0] >= 0 and pos[1] >= 0 and data[pos[1]] != nil and data[pos[1]][pos[0]] != nil
		cnt += 1
		break if data[pos[1]][pos[0]] >= curr
		pos = stepper(pos, dir)
	end
	cnt
end

def solve2(data)
	h = data.length
	w = data.first.length
	(1..h-2).map do |y|
		(1..w-2).map do |x|
			v1=scan2(data, [x,y], [1, 0])
			v2=scan2(data, [x,y], [-1, 0])
			v3=scan2(data, [x,y], [0, 1])
			v4=scan2(data, [x,y], [0, -1])
			v1*v2*v3*v4
		end
	end.flatten.max
end

# solve

p solve1(data)
p solve2(data)

# 00:16:25 1820 2226
# 00:32:08 385112 2462
