# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |line|
  line.split('   ').map(&:to_i)
end

first = data.map { |item| item[0] }.sort
second = data.map { |item| item[1] }.sort
pt1 = first.zip(second).map do |a, b|
  (a-b).abs
end.sum
p(pt1)

pt2 = first.map do |item|
  cnt2 = (second.filter{ |item2| item2 == item }.count)
  item * cnt2
end.sum
p(pt2)

# 1222801
# 22545250
