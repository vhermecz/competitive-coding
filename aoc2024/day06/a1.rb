require 'set'

# INPUT='test'
INPUT='input'

DIRS = {
  0 => [-1, 0],  # up
  1 => [0, 1],   # right
  2 => [1, 0],   # down
  3 => [0, -1],  # left
}

spos = [0, 0]
sdir = 0
maze = File.read(INPUT).split("\n").each_with_index.map do |line, y|
  x = line.index("^")
  spos = [y, x] if !x.nil?
  line.split("")
end

# March until looping or leaving
# @return [Integer, Boolean] number of visited locations, guard started looping
def march(maze, spos, sdir)
  w = maze.first.length
  h = maze.length
  cpos = spos.dup
  cdir = sdir
  visited = Set.new
  loop = false
  while true do
    state = [cpos, cdir]
    loop = visited.include?(state)
    break if loop
    visited.add(state)
    npos = [cpos.first + DIRS[cdir].first, cpos.last + DIRS[cdir].last]
    break if npos.first < 0 || npos.first >= h || npos.last < 0 || npos.last >= w
    if maze[npos.first][npos.last] == "#"
      cdir = (cdir + 1) % 4
    else
      cpos = npos
    end
  end
  n_pos = visited.map{|state|state.first}.uniq.length
  [n_pos, loop]
end

# solve
p1 = march(maze, spos, sdir).first
p p1

p2 = maze.first.length.times.map do |by|
  maze.length.times.map do |bx|
    next 0 if [by, bx] == spos
    cmaze = maze.map{|line|line.dup}
    cmaze[by][bx] = "#"
    march(cmaze, spos, sdir).last ? 1 : 0
  end.sum
end.sum
p p2

# 4752
# 1719
#
# real	3m25,681s
# user	3m25,407s
# sys	0m0,132s
