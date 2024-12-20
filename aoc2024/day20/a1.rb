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
def compute_distance(walls, pos_start)
  distance = Hash.new
  visited = Set.new
  expand = Heap.new{|a,b|a.first<b.first}
  expand << [0, pos_start]
  result = []
  until expand.empty?
    cost, pos = expand.pop
    next if visited.include?(pos)
    distance[pos] = cost
    visited << pos
    DIRS.each do |dir|
      nextpos = pos + dir
      next if nextpos.first < 0 || nextpos.first >= $h
      next if nextpos[1] < 0 || nextpos[1] >= $w
      next if walls.include? nextpos
      expand << [cost+1, nextpos]
    end
  end
  distance
end


def solve(walls, pos_start, pos_end, distances, max_cheat)
  raw_cost = distances[pos_start]
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
    # cheats
    (pos[0]-max_cheat..pos[0]+max_cheat).to_a.each do |r|
      (pos[1]-max_cheat..pos[1]+max_cheat).to_a.each do |c|
        dist = (pos.first-r).abs + (pos[1]-c).abs
        cost_left = distances[Vector[r,c]]
        if dist <= max_cheat && !cost_left.nil? && cost + dist + cost_left < raw_cost
          result << (cost + dist + cost_left)
        end
      end
    end
    DIRS.each do |dir|
      nextpos = pos + dir
      next if nextpos.first < 0 || nextpos.first >= $h
      next if nextpos[1] < 0 || nextpos[1] >= $w
      next if walls.include? nextpos
      expand << [cost+1, nextpos]
    end
  end
end

distances = compute_distance(walls, pos_end)
no_cheat_cost = distances[pos_start]
# p no_cheat_cost
p solve(walls, pos_start, pos_end, distances, 2).filter{|v|v<=no_cheat_cost-100}.length
p solve(walls, pos_start, pos_end, distances, 20).filter{|v|v<=no_cheat_cost-100}.length

# 1501 - bad (at least 101, instead of 100)