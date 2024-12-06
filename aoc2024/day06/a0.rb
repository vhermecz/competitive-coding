require 'set'

INPUT='test'
# INPUT='input'

DIRS = {
  0 => [-1, 0],  # up
  1 => [0, 1],   # right
  2 => [1, 0],   # down
  3 => [0, -1],  # left
}

cpos = [0, 0]
cdir = 0
data = File.read(INPUT).split("\n").each_with_index.map do |line, y|
  x = line.index("^")
  cpos = [y, x] if !x.nil?
  line.split("")
end

w = data.first.length
h = data.length
orig = data.map{|line|line.dup}
opos = cpos.dup
odir = cdir

# solve
# part1
data[cpos.first][cpos.last] = "X"
while true do
  npos = [cpos.first + DIRS[cdir].first, cpos.last + DIRS[cdir].last]
  break if npos.first < 0 || npos.first >= h || npos.last < 0 || npos.last >= w
  if data[npos.first][npos.last] == "#"
    cdir = (cdir + 1) % 4
  else
    cpos = npos
    data[cpos.first][cpos.last] = "X"
  end
end

p1 = data.map do |line|
  line.join("")
end.join("").count("X")

p p1

# part2
p2 = 0
w.times do |ty|
  h.times do |tx|
    next if ty == opos.first && tx == opos.last
    data = orig.map{|line|line.dup}
    cdir = odir
    cpos = opos.dup
    data[ty][tx] = "#"
    visited = Set.new
    loop = false
    while true do
      npos = [cpos.first + DIRS[cdir].first, cpos.last + DIRS[cdir].last]
      break if npos.first < 0 || npos.first >= h || npos.last < 0 || npos.last >= w
      if data[npos.first][npos.last] == "#"
        cdir = (cdir + 1) % 4
      else
        cpos = npos
        state = [cpos, cdir]
        loop = visited.include?(state)
        break if loop
        visited.add(state)
        data[cpos.first][cpos.last] = "X"
      end
    end
    p2 += 1 if loop
  end
end

p p2
