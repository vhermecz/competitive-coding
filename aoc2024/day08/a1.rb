require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT)
maze = data.split("\n").map do |line|
  line.split("")
end
h = maze.length
w = maze.first.length

antenna_sets = h.times.map do |y|
  w.times.map do |x|
    [y, x] if maze[y][x] != '.'
  end
end.flatten(1).compact.group_by{|c|maze[c[0]][c[1]]}.values

def solve(h, w, antenna_sets, single_step)
  steps = single_step ? (1..1) : (0..[h, w].max)
  antenna_sets.map do |positions|
    positions.combination(2).map do |p1, p2|
      [
        [p2, [p2[0]-p1[0], p2[1]-p1[1]]],
        [p1, [p1[0]-p2[0], p1[1]-p2[1]]],
      ].map do |p, pd|
        steps.map do |i|
          [p[0]+pd[0]*i, p[1]+pd[1]*i]
        end.take_while do |y, x|
          y >= 0 && y < h && x >= 0 && x < w
        end
      end
    end
  end.flatten(3).uniq.compact.length
end

p solve(h, w, antenna_sets, true)
p solve(h, w, antenna_sets, false)
