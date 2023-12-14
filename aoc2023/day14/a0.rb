require 'set'

INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row.split("")
end

# solve

def gravitate_once data
	changed = false
	data.length.times.each do |y|
		next if y == 0
		data[0].length.times.each do |x|
			if data[y-1][x] == '.' && data[y][x] == 'O'
				data[y-1][x] = 'O'
				data[y][x] = '.'
				changed = true
			end
		end
	end
	changed
end

def rotate_90cc data
	ndata = data.map{|r|r.dup}
	n_row = data.length
	n_row.times.each do |y|
		data[0].length.times.each do |x|
			ndata[x][n_row-1-y] = data[y][x]
		end
	end
	ndata
end

def gravitate data
	changed = true
	while changed
		changed = gravitate_once data
	end
	data
end

## north, then west, then south, then east.
def gravitate_cycle data
	4.times.each do 
		gravitate data
		data = rotate_90cc data
	end
	data
end

def dbg(x)
	x.each do |r|
		p r.join("")
	end
end

def score data
	n_row = data.length
	data.each_with_index.map do |row, idx|
		row.filter{|v|v=='O'}.length * (n_row - idx)
	end.sum
end

def encode data
	data.flatten.join("")
end

def part1 data
	data = data.map{|r|r.dup}
	gravitate(data)
	score(data)
end

def part2 data
	data = data.map{|r|r.dup}
	mem = {}

	i = 0
	looplen = 0
	loopstart = 0
	mem[encode(data)] = 0
	while true
		data = gravitate_cycle data
		i+=1
		enc = encode(data)
		if !mem[enc].nil?
			loopstart = mem[enc]
			looplen = i - loopstart
			break
		end
		mem[enc] = i
	end

	rem = (1000000000 - loopstart) % looplen
	rem.times.each do
		data = gravitate_cycle(data)
	end

	score(data)
end

p part1(data)
p part2(data)

# 14   00:10:02   1142      0   00:37:44   1073      0
# 108889
# 104671
