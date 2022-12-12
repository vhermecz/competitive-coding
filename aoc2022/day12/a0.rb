# gem install rb_heap
require 'rb_heap'
require 'set'

#INPUT='test'
INPUT='input'

# read_input
$data = File.read(INPUT).split("\n").map{|r|r.split("")}

$h = $data.length
$w = $data[0].length

NBS = [
	[1, 0],
	[-1, 0],
	[0, 1],
	[0, -1],
]

# solve

def elev(pos)
	val = $data[pos[1]][pos[0]]
	val = 'z' if val == 'E'
	val = 'a' if val == 'S'
	return val.ord
end

def debug(visited)
	$h.times do |r|
		$w.times do |c|
			print visited[[c,r]].to_s.rjust(3)
		end
		puts
	end
	puts
	$h.times do |r|
		$w.times do |c|
			print $data[r][c].to_s.rjust(3)
		end
		puts
	end
end

def solve(anya: False)
	visited = Hash.new
	expand = Heap.new{|a, b| a[0] < b[0]}
	$h.times do |r|
		$w.times do |c|
			expand.add [0, [c, r]] if $data[r][c] == 'a' and anya==true
			expand.add [0, [c, r]] if $data[r][c] == 'S'
		end
	end
	while !expand.empty? do
		cost, pos = expand.pop
		x, y = pos
		break if $data[y][x] == 'E'
		next if visited[pos]
		visited[pos] = cost
		NBS.each do |dx,dy|
			nx, ny = x+dx, y+dy
			next unless nx >= 0 and nx < $w and ny >= 0 and ny < $h
			next if elev([nx,ny])-elev([x,y]) > 1
			expand.add [cost + 1, [nx, ny]]
		end
	end
	cost
end

p solve(anya:false)
p solve(anya:true)

# ~27 381 bad (forgot height of E)
# 28:01 361 1859
# 29:15 354 1439
