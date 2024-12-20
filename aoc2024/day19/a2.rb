# INPUT='test'
INPUT='input'

# read_input

tiles, targets = File.read(INPUT).split("\n\n")
tiles = tiles.split(", ")
targets = targets.split("\n")

class Solver
  def initialize(tiles)
    @tiles = tiles
    @memo = {}
  end
  def count(target)
    return 1 if target.length == 0
    return @memo[target] unless @memo[target].nil?
    cnt = 0
    @tiles.each do |tile|
      if target.start_with?(tile)
        cnt += count(target[tile.length..])
      end
    end
    @memo[target] = cnt
  end
end

# solve
solver = Solver.new(tiles)
target_counts = targets.map{|v|solver.count(v)}
p target_counts.filter{|v|v>0}.length
p target_counts.sum
