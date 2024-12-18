require 'set'
require 'rb_heap'
require 'matrix'

# INPUT='test'
INPUT='input'

DIRS = [
  Vector[0, 1],
  Vector[1, 0],
  Vector[0, -1],
  Vector[-1, 0],
]

coordinates = File.read(INPUT).split("\n").map do |line|
  line.split(",").map(&:to_i).reverse   # are col, row, swap it
end

$w, $h, $limit = if INPUT == "test"
                   [7, 7, 12]
                 else
                   [71, 71, 1024]
                 end

pos_start = Vector[0, 0]
pos_end = Vector[$w-1, $h-1]

def solve(coordinates, pos_start, pos_end)
  walls = coordinates.map{|c|Vector[*c]}.to_set
  visited = Set.new
  expand = Heap.new{|a,b|a.first<b.first}
  expand << [0, pos_start]
  until expand.empty?
    cost, pos = expand.pop
    return cost if pos == pos_end
    next if visited.include?(pos)
    visited << pos
    DIRS.each do |dir|
      nextpos = pos + dir
      next if nextpos.first < 0 || nextpos.first >= $h
      next if nextpos[1] < 0 || nextpos[1] >= $h
      next if walls.include? nextpos
      expand << [cost+1, nextpos]
    end
  end
end

# solve
p solve(coordinates[...$limit], pos_start, pos_end)
p solve(coordinates[...2936], pos_start, pos_end)
p solve(coordinates[...2937], pos_start, pos_end)
p coordinates[2936].reverse.join ","  # guilty of bisect by hand
