require 'set'

#INPUT='test'
INPUT='input'

# read_input
def load(fname, infifloor:false)
	data = File.read(INPUT).split("\n").map do |r|
		r.split(" -> ").map{|c|c.split(",").map(&:to_i)}
	end
	sand_x = 500
	sand_y = 0
	max_y = data.flatten(1).map{|i|i[1]}.max
	extra = max_y + 2  # give some space for 'infinite' plane
	min_x = data.flatten(1).map{|i|i[0]}.min 
	min_x -= extra if infifloor
	min_y = data.flatten(1).map{|i|i[1]}.min
	min_y = 0

	data = data.map do |path|
		path.map do |coord|
			[coord[0]-min_x, coord[1]-min_y]
		end
	end
	sand_x -= min_x
	#sand_y -= min_y
	w = data.flatten(1).map{|i|i[0]}.max + 1
	h = data.flatten(1).map{|i|i[1]}.max + 1
	data << [[0,h-1+2], [w-1+extra, h-1+2]] if infifloor
	w = data.flatten(1).map{|i|i[0]}.max + 1
	h = data.flatten(1).map{|i|i[1]}.max + 1

	[data, [w, h], [sand_x, sand_y]]
end

def dbg(box)
	box.length.times do |r|
		p box[r].join("")
	end
end

def drop(box, start)
	x, y = start
	h = box.length
	w = box.first.length
	return false if box[y][x] != 0
	while true do
		if y+1 == h
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
		elsif x+1 == w
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

def draw(data, dim)
	w, h = dim
	box = h.times.map{[0] * w}
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
	box
end

def solve(fname, infifloor:false)
	data, dim, sand = load(fname, infifloor:infifloor)
	box = draw(data, dim)
	cnt = 0
	while drop(box, sand) do
		cnt += 1
	end
	cnt
end

p solve(INPUT, infifloor:false)
p solve(INPUT, infifloor:true)

# 00:24:31 592 1175
# 34:55 978 bad (width too narrow)
# 35:57 14971 bad (width too narrow)
# 36:58 30367 1708
