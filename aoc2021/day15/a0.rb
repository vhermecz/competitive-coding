require 'set'
require 'algorithms'  # https://stackoverflow.com/a/4204444/1442987

#INPUT='test'
INPUT='input'

# read_input
$data = []
File.open( INPUT ) do |f|
	$data = f.map do |row|
		row.strip.split("").map(&:to_i)
	end
end

$h = $data.length
$w = $data[0].length

NBS = [
	[1, 0],
	[-1, 0],
	[0, 1],
	[0, -1],
]

# grow
GROW = 5
$data = ($h*GROW).times.map do |y|
	($w*GROW).times.map do |x|
		($data[y%$h][x%$h] + y/$h + x/$w - 1) % 9 + 1
	end
end
$w *= GROW
$h *= GROW

# solve
visited = Hash.new
expand = Containers::MinHeap.new
expand.push [0, [0, 0]]

while !expand.empty? do
	cost, pos = expand.pop
	break if pos == [$w-1, $h-1]
	next if visited[pos]
	visited[pos] = cost
	NBS.each do |dx,dy|
		x, y = pos
		nx, ny = x+dx, y+dy
		next unless nx >= 0 and nx < $w and ny >= 0 and ny < $h
		expand.push [cost + $data[ny][nx], [nx, ny]]
	end
end

p cost
# 00:14:55    770 - 540
# 00:22:28    304 - 2879 (runtime is 37sec, meh)
