require 'set'
require 'rb_heap'
require 'matrix'

DIRS = [
  Vector[0, 1],
  Vector[1, 0],
  Vector[0, -1],
  Vector[-1, 0],
]

INPUT='test'
INPUT='input'

# read_input
# data = []
# File.open( INPUT ) do |f|
# 	while true do
# 		row = f.gets.strip
# 		break if row.empty?
# 		data << row.split(",").map(&:to_i)
# 	end
# end
maze = File.read(INPUT).split("\n").map do |line|
  line.split("")
end

pos_start = nil
pos_end = nil
walls = Set.new
$h = maze.length
$w = maze.first.length
$h.times do |r|
  $w.times do |c|
    pos_start = Vector[r, c] if maze[r][c] == 'S'
    pos_end = Vector[r, c] if maze[r][c] == 'E'
    walls << Vector[r, c] if maze[r][c] == '#'
  end
end


# solve

def solve(walls, pos_start, pos_end, allow_cheat=false)
  visited = Set.new
  expand = Heap.new{|a,b|a.first<b.first}
  expand << [0, pos_start]
  result = []
  until expand.empty?
    cost, pos = expand.pop
    if pos == pos_end
      result << cost
      return result
    end
    next if visited.include?(pos)
    visited << pos
    DIRS.each do |dir|
      nextpos = pos + dir
      next if nextpos.first < 0 || nextpos.first >= $h
      next if nextpos[1] < 0 || nextpos[1] >= $w
      if allow_cheat && walls.include?(nextpos)
        nextpos2 = nextpos + dir
        rfit = !(nextpos2.first < 0 || nextpos2.first >= $h)
        cfit = !(nextpos2[1] < 0 || nextpos2[1] >= $w)
        if cfit && rfit && !walls.include?(nextpos2) && !visited.include?(nextpos2)
          a = solve(walls, nextpos2, pos_end, false).first
          result << (cost + 2 + a)
        end
      end
      next if walls.include? nextpos
      expand << [cost+1, nextpos]
    end
  end
end

results = solve(walls, pos_start, pos_end, true).sort
top = results.last
p results.filter{|v|v<top-100}.length