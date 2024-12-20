require 'set'

INPUT='test'
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
  def solvable(target)
    return true if target.length == 0
    return @memo[target] unless @memo[target].nil?
    @tiles.each do |tile|
      if target.start_with?(tile)
        res = solvable(target[tile.length..])
        if res
          @memo[target] = true
          return true
        end
      end
    end
    @memo[target] = false
  end
end


# solve
x = Solver.new(tiles)
p targets.filter{|v|x.solvable(v)}.length