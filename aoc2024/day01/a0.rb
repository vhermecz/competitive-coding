require 'set'

SENTINEL = 99999999

# INPUT='test'
INPUT='input'

class Array
  def all_index(target)
    indices = []
    each_with_index do |num, index|
      indices << index if num == target
    end
    indices
  end
end

# read_input
data = File.read(INPUT).split("\n").map do |line|
  line.split('   ').map(&:to_i)
end

data = data.map do |line|
  [line[1], line[0]]
end

def distance_of_smallest(state)
  first = state.map { |item| item[0] }
  first_smallest = first.sort[0]
  first_smallest_index = first.index(first_smallest)
  second = state.map { |item| item[1] }
  second_smallest = second.sort[0]
  second_smallest_index = second.all_index(second_smallest).map.with_index do |row|
    [(row[0]-first_smallest).abs, row[1]]
  end.sort[0][1]

  dist = (second_smallest_index-first_smallest_index).abs
  state[first_smallest_index][0] = SENTINEL
  state[second_smallest_index][1] = SENTINEL
  finished = first.uniq.length == 1
  [dist, finished]
end

# solve
total_dist = 0
while true
  next_dist, finished = distance_of_smallest(data)
  #p(next_dist)
  total_dist += next_dist
  break if finished
end
p(total_dist)


# 499500 wrong answer - too low
# 498503 wrong answer - too low o_O
