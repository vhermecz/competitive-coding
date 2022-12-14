require 'set'

INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |r|
	r.split(" -> ").map{|c|c.split(",").map(&:to_i)}
end
sand_x = 500
sand_y = 0
extra = 200
min_x = data.flatten(1).map{|i|i[0]}.min - extra
min_y = data.flatten(1).map{|i|i[1]}.min
min_y = 0

data = data.map do |path|
	path.map do |coord|
		[coord[0]-min_x, coord[1]-min_y]
	end
end
sand_x -= min_x
sand_y -= sand_y
$w = data.flatten(1).map{|i|i[0]}.max + 1
$h = data.flatten(1).map{|i|i[1]}.max + 1
data << [[0,$h-1+2], [$w-1+extra, $h-1+2]]  # switch between part1&2
$w = data.flatten(1).map{|i|i[0]}.max + 1
$h = data.flatten(1).map{|i|i[1]}.max + 1

#test
# 494 503 => 10
# 4 9 => 6
# input
#463  519 => 57
#15 176 => 162

def dbg(box)
	$h.times do |r|
		p box[r].join("")
	end
end

def drop(box, start)
	x, y = start
	return false if box[y][x] != 0
	while true do
		if y+1 == $h
			return false 
		elsif box[y+1][x] == 0
			y += 1
			next
		elsif x == 0
			return false
		elsif box[y+1][x-1] == 0
			y += 1
			x -= 1
			next
		elsif x+1 == $w
			return false
		elsif box[y+1][x+1] == 0
			y += 1
			x += 1
			next
		else
			box[y][x] = 1
			return true
		end
	end
end

box = $h.times.map{[0] * $w}
data.each do |path|
	path.each_cons(2) do |a, b|
		len = [(a[0]-b[0]).abs, (a[1]-b[1]).abs].max
		(len+1).times do |step|
			x = a[0] + (b[0]-a[0]) * step / len
			y = a[1] + (b[1]-a[1]) * step / len
			box[y][x] = 1
		end
	end
end
#dbg(box)
cnt = 0
while drop(box, [sand_x, sand_y]) do
	cnt += 1
end
#p [box]
#dbg(box)
p cnt
# solve

# 00:24:31 592 1175
# 34:55 978 bad (width too narrow)
# 35:57 14971 bad (width too narrow)
# 36:58 30367 1708
