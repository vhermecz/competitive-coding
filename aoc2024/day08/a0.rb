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

freqs = maze.flatten.uniq.filter{|v|v!='.'}
freq_sets = Hash.new { |hash, key| hash[key] = [] }

h.times do |y|
  w.times do |x|
    freq_sets[maze[y][x]] << [y, x] if maze[y][x] != '.'
  end
end

antennas_all = freq_sets.values.flatten(1).to_set

# part1
# 2b - a
# 2a - b
anodes =  Set.new
freq_sets.each do |_, freq_list|
  freq_list.combination(2) do |p1, p2|
    [
      [2*p1[0]-p2[0], 2*p1[1]-p2[1]],
      [2*p2[0]-p1[0], 2*p2[1]-p1[1]],
    ].each do |anode|
      # next if antennas_all.include?(anode)
      next if anode[0] < 0 || anode[0] >= h
      next if anode[1] < 0 || anode[1] >= w
      anodes << anode
    end
  end
end
p anodes.size


# part2
# p + n*d
anodes =  Set.new
freq_sets.each do |_, freq_list|
  freq_list.combination(2) do |p1, p2|
    [
      [p2, [p2[0]-p1[0], p2[1]-p1[1]]],
      [p1, [p1[0]-p2[0], p1[1]-p2[1]]],
    ].each do |p, pd|
      while true
        anodes << p
        p = [p[0]+pd[0], p[1]+pd[1]]
        break if p[0] < 0 || p[0] >= h
        break if p[1] < 0 || p[1] >= w
        # break
      end
    end
  end
end
p anodes.size
# 259 wrong
# 254 good
# 1257 wrong