require 'set'

FIELD_WALL = "#"
FIELD_BOX  = "O"
FIELD_BOT  = "@"
FIELD_EMPTY= "."
FIELD_BOX_LEFT  = "["
FIELD_BOX_RIGHT  = "]"

INFLATOR_MAP = {
  FIELD_EMPTY => [FIELD_EMPTY, FIELD_EMPTY],
  FIELD_BOT => [FIELD_BOT, FIELD_EMPTY],
  FIELD_WALL => [FIELD_WALL, FIELD_WALL],
  FIELD_BOX => [FIELD_BOX_LEFT, FIELD_BOX_RIGHT]
}

DIRS = {
  ">" => [0, 1],
  "^" => [-1, 0],
  "v" => [1, 0],
  "<" => [0, -1],
}

# INPUT='test'
INPUT='input'

def load_input(fname, inflate_maze=false)
  maze, steps = File.read(fname).split("\n\n")
  maze = maze.split("\n").map do |line|
    line.split("")
  end
  steps = steps.strip.split("").filter{|v|v!="\n"}
  maze = inflate(maze) if inflate_maze
  h = maze.length
  w = maze.first.length
  robot_pos = nil
  h.times do |r|
    w.times do |c|
      robot_pos = [r, c] if maze[r][c] == FIELD_BOT
    end
  end
  [maze, steps, robot_pos]
end

def inflate(maze)
  maze.map do |line|
    line.map do |field|
      INFLATOR_MAP[field]
    end.flatten
  end
end

def move(maze, pos, dir)
  r, c = pos
  nr = r + DIRS[dir].first
  nc = c + DIRS[dir].last
  npos = [nr, nc]
  pos_otherhalf = nil
  npos_otherhalf = nil
  field = maze[r][c]
  return npos if field == FIELD_EMPTY
  return nil if field == FIELD_WALL
  is_wide_box = field == FIELD_BOX_LEFT || field == FIELD_BOX_RIGHT
  check_other_half = (dir == "^" || dir == "v") && is_wide_box
  if check_other_half
    pos_otherhalf = [r, c+1*(field == FIELD_BOX_LEFT ? 1 : -1)]
    npos_otherhalf = [nr, nc+1*(field == FIELD_BOX_LEFT ? 1 : -1)]
    return nil if move(maze.map(&:dup), npos_otherhalf, dir).nil?
  end
  return nil if move(maze, npos, dir).nil?
  if check_other_half
    move(maze, npos_otherhalf, dir).nil?
  end
  maze[nr][nc] = field
  maze[r][c] = FIELD_EMPTY
  unless npos_otherhalf.nil?
    field_otherhalf = maze[pos_otherhalf.first][pos_otherhalf.last]
    maze[npos_otherhalf.first][npos_otherhalf.last] = field_otherhalf
    maze[pos_otherhalf.first][pos_otherhalf.last] = FIELD_EMPTY
  end
  npos
end

def score(maze)
  h = maze.length
  w = maze.first.length
  score = 0
  h.times do |r|
    w.times do |c|
      score += 100*r+c if maze[r][c] == FIELD_BOX || maze[r][c] == FIELD_BOX_LEFT
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

p solve(*load_input(INPUT))
p solve(*load_input(INPUT, true))

# 1486930
# 1489552 too low (tx issue)
# 1492011
