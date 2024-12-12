require 'set'
require 'matrix'

# INPUT='test2'
INPUT='input'

# read_input
maze = File.read(INPUT).split("\n").map do |line|
  line.split("")
end

DIR = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0],
]
DIRV = DIR.map{|v|Vector.elements v}

def cluster_plants(maze)
  h = maze.length
  w = maze.first.length
  coordinates = h.times.to_a.product(w.times.to_a)
  plants = coordinates.group_by{|r,c|maze[r][c]}.values
  plants.map do |plant|
    cluster_connected(plant)
  end.flatten(1)
end

def count_horizontal_neighbours(fields)
  fields.sort.each_cons(2).map do |a, b|
    a.first == b.first && a.last+1 == b.last ? 1 : 0
  end.sum
end

def perimeter(fields)
  fields.length * 4 -
    count_horizontal_neighbours(fields) * 2 -
    count_horizontal_neighbours(fields.map(&:reverse)) * 2
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

def sides_outside(fields)
  trace(fields).map(&:last).each_cons(2).map do |a, b|
    a!=b ? 1: 0  # count turns
  end.sum + 1
end

def fill_holes(fields)
  trace(fields).sort.filter do |v|
    DIR[v.last].last == 0  # vertical dir
  end.map(&:first).each_slice(2).map do |a, b|
    r1, c1 = a
    _, c2 = b
    (c1..c2).map do |c|
      [r1, c]
    end
  end.flatten(1)
end

def cluster_connected(fields)
  clusters = []
  universe = fields.to_set
  until universe.empty?
    component = []
    expand = [universe.first]
    universe.delete expand.first
    until expand.empty?
      r, c = expand.pop
      component << [r, c]
      DIR.each do |dr, dc|
        npos = [r+dr, c+dc]
        expand << npos unless universe.delete?(npos).nil?
      end
    end
    clusters << component
  end
  clusters
end

def sides(fields)
  holes = cluster_connected(fill_holes(fields).to_set - fields.to_set)
  sides_outside(fields) + holes.map{|hole|sides_outside(hole)}.sum
end

p cluster_plants(maze).map{|fields|fields.length * perimeter(fields)}.sum
p cluster_plants(maze).map{|fields|fields.length * sides(fields)}.sum

# 1370100
# 818286
