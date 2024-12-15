require 'set'

FIELD_WALL = "#"
FIELD_BOX  = "O"
FIELD_BOT  = "@"
FIELD_EMPTY= "."

DIRS = {
  ">" => [0, 1],
  "^" => [-1, 0],
  "v" => [1, 0],
  "<" => [0, -1],
}

INPUT='test'
INPUT='input'

# read_input
maze, steps = File.read(INPUT).split("\n\n")
maze = maze.split("\n").map do |line|
  line.split("")
end
steps = steps.strip.split("").filter{|v|v!="\n"}
p steps

h = maze.length
w = maze.first.length

robot_pos = nil
h.times do |r|
  w.times do |c|
    robot_pos = [r, c] if maze[r][c] == FIELD_BOT
  end
end

def move(maze, pos, dir)
  r, c = pos
  nr = r + DIRS[dir].first
  nc = c + DIRS[dir].last
  npos = [nr, nc]
  field = maze[r][c]
  return npos if field == FIELD_EMPTY
  return nil if field == FIELD_WALL
  return nil if move(maze, [nr, nc], dir).nil?
  maze[nr][nc] = field
  maze[r][c] = FIELD_EMPTY
  npos
end

def score(maze)
  h = maze.length
  w = maze.first.length
  score = 0
  h.times do |r|
    w.times do |c|
      score += 100*r+c if maze[r][c] == FIELD_BOX
    end
  end
  score
end

def solve(maze, steps, robot_pos)
  pos = robot_pos
  steps.each do |step|
    pos = move(maze, pos, step) || pos
  end
  score(maze)
end

p solve(maze, steps, robot_pos)

# solve
