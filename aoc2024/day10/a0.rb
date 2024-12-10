require 'set'

# INPUT='test2'
INPUT='input'

# read_input
$maze = File.read(INPUT).split("\n").map do |line|
  line.split('').map(&:to_i)
end
$h = $maze.length
$w = $maze.first.length

def count_trailhead(r, c, v)
  return [] if r < 0 || c < 0 || r >= $h || c >= $w
  return [] if $maze[r][c] != v
  return [[r,c]] if v == 9
  count_trailhead(r-1, c, v+1) +
    count_trailhead(r+1, c, v+1) +
    count_trailhead(r, c-1, v+1) +
    count_trailhead(r, c+1, v+1)
end

trails = $h.times.map do |r|
  $w.times.map do |c|
    count_trailhead(r, c, 0)
  end
end.flatten(1)

p trails.map{|t|t.uniq.length}.sum
p trails.map{|t|t.length}.sum

# 737
# 1619
