require 'set'
require 'matrix'

# INPUT='test2'
INPUT='input'

# read_input
$maze = File.read(INPUT).split("\n").map do |line|
  line.split("")
end
$h = $maze.length
$w = $maze.first.length
$maze2 = $maze.map(&:dup)

DIR = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0],
]

DIRV = DIR.map{|v|Vector.elements v}

def fillfrom(r, c)
  expand = [[r, c]]
  visited = []
  plant = $maze[r][c]
  return visited if plant == "."
  while expand.length > 0
    r,c = expand.pop
    visited << [r, c]
    $maze[r][c] = "."
    DIR.each do |dr, dc|
      nr = r + dr
      nc = c + dc
      next if nr<0 || nr >= $h
      next if nc<0 || nc >= $w
      next if $maze[nr][nc] != plant
      expand << [nr, nc]
    end
  end
  visited.uniq
end

def count_neighbours(fields)
  fields.each_cons(2).map do |a, b|
    a.first == b.first && a.last+1 == b.last ? 1 : 0
  end.sum
end

def perimeter(fields)
  base = fields.length * 4
  base -= count_neighbours(fields.sort) * 2
  base -= count_neighbours(fields.map{|a,b|[b,a]}.sort) * 2
  base
end

def trace(fields)
  return [] if fields.empty?
  pos = Vector.elements fields.sort.first
  fields = fields.to_set
  dir = 0
  points = []
  while points.first != [pos.to_a, dir]
    points << [pos.to_a, dir]
    fwd = pos + DIRV[dir]
    fwd_left = fwd + DIRV[dir-1]
    if fields.include?(fwd_left.to_a)
      pos = fwd_left
      dir -= 1
    elsif fields.include?(fwd.to_a)
      pos = fwd
    else
      dir = (dir + 1) % DIRV.length
    end
  end
  points
end

def sides_hull(fields)
  a = trace(fields).map(&:last).each_cons(2).map do |a, b|
    a!=b ? 1: 0
  end.sum + 1
end

def convex_hull(fields)
  trace(fields).sort.filter{|v|v.last%2==1}.map(&:first).each_slice(2).map do |a, b|
    r = a.first
    c1 = a.last
    c2 = b.last
    (c1..c2).map do |c|
      [r, c]
    end
  end.flatten(1).to_set
end

def cluster_holes(fields)
  clusters = []
  universe = fields.to_set
  until universe.empty?
    component = []
    expand = [fields.first]
    universe.delete expand.first
    until expand.empty?
      pos = expand.pop
      component << pos
      DIR.each do |dr, dc|
        r, c = pos
        nr = r + dr
        nc = c + dc
        npos = [nr, nc]
        next unless universe.include?(npos)
        expand << npos
        universe.delete npos
      end
    end
    clusters << component
  end
  clusters
end

def sides(fields)
  base = sides_hull(fields)
  holes = convex_hull(fields) - fields.to_set
  cluster_holes(holes).each do |hole|
    base += sides_hull(hole)
  end
  base
end

# solve
p1 = $h.times.map do |r|
  $w.times.map do |c|
    fields = fillfrom(r, c).uniq
    fields.length * perimeter(fields)
  end.sum
end.sum

p p1

$maze = $maze2.map(&:dup)
p2 = $h.times.map do |r|
  $w.times.map do |c|
    fields = fillfrom(r, c).uniq
    fields.length * sides(fields)
  end.sum
end.sum

p p2

# 1370100
# 818286
#