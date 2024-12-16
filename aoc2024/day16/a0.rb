require 'set'
require 'rb_heap'
require 'matrix'

INPUT='test'
INPUT='input'

DIRS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0],
]

maze = File.read(INPUT).split("\n").map do |line|
  line.split("")
end
h = maze.length
w = maze.first.length

pos_start = nil
pos_end = nil

h.times do |r|
  w.times do |c|
    pos_start = [r, c] if maze[r][c] == "S"
    pos_end = [r, c] if maze[r][c] == "E"
  end
end

def solve(maze, pos_start, pos_end)
  visited = Set.new
  expand = Heap.new{|a,b|a.first<b.first}
  expand << [0, [pos_start, 0]]
  until expand.empty?
    curr_cost, curr_state = expand.pop
    next if visited.include?(curr_state)
    visited << curr_state
    curr_pos, curr_dir = curr_state
    if curr_pos == pos_end
      return curr_cost
    end
    DIRS.length.times.each do |next_dir|
      # next if (next_dir-curr_dir)%4==2
      turn_cost = 0
      if next_dir == curr_dir
        turn_cost = 0

      elsif (next_dir-curr_dir)%4==2
        turn_cost = 2
      else
        turn_cost = 1
      end

      cost = turn_cost * 1000 + 1
      r, c = (Vector[*curr_pos] + Vector[*DIRS[next_dir]]).to_a
      next if maze[r][c] == "#"
      expand << [curr_cost + cost, [[r,c], next_dir]]
    end
  end
end

p solve(maze, pos_start, pos_end)

# solve
