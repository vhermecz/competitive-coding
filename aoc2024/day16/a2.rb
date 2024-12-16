require 'set'
require 'rb_heap'
require 'matrix'

# INPUT='test'
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
  visited = Hash.new
  expand = Heap.new{|a,b|a.first<b.first}
  expand << [0, [pos_start, 0], [pos_start, 0]]
  best_score = nil
  until expand.empty?
    curr_cost, curr_state, from_state = expand.pop
    if visited.include?(curr_state)
      if visited[curr_state].first.first == curr_cost
        visited[curr_state] << [curr_cost, from_state]
      end
      next
    end
    visited[curr_state] = [[curr_cost, from_state]]
    curr_pos, curr_dir = curr_state
    best_score = curr_cost if curr_pos == pos_end and best_score.nil?
    break if !best_score.nil? && curr_cost > best_score
    DIRS.length.times.each do |next_dir|
      next if (next_dir-curr_dir)%4==2
      turn_cost = next_dir == curr_dir ? 0 : 1
      cost = turn_cost * 1000 + 1
      r, c = (Vector[*curr_pos] + Vector[*DIRS[next_dir]]).to_a
      next if maze[r][c] == "#"
      expand << [curr_cost + cost, [[r,c], next_dir], curr_state]
    end
  end
  expand2 = []
  DIRS.length.times.each do |next_dir|
    end_state = [pos_end, next_dir]
    expand2 << end_state if visited.include?(end_state)
  end
  visited2 = Set.new
  until expand2.empty?
    curr_state = expand2.pop
    next if visited2.include?(curr_state)
    visited2 << curr_state
    visited[curr_state].each do |_, from_state|
      expand2 << from_state
    end
  end
  visited3 = visited2.map(&:first).uniq
  [best_score, visited3.length]
end

result = solve(maze, pos_start, pos_end)
p result.first
p result.last
