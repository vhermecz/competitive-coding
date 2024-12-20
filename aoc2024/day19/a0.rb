require 'set'

INPUT='test'
INPUT='input'

# read_input
# data = []
# File.open( INPUT ) do |f|
# 	while true do
# 		row = f.gets.strip
# 		break if row.empty?
# 		data << row.split(",").map(&:to_i)
# 	end
# end
tiles, targets = File.read(INPUT).split("\n\n")
tiles = tiles.split(", ")
targets = targets.split("\n")

def solvable(target, tiles)
  return true if target.length == 0
  tiles.each do |tile|
    if target.start_with?(tile)
      res = solvable(target[tile.length..], tiles)
      return true if res
    end
  end
  return false
end

# solve
p targets.filter{|v|solvable(v, tiles)}.length