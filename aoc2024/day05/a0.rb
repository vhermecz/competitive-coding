require 'set'

# INPUT='test'
INPUT='input'

ordering, lists = File.read(INPUT).split("\n\n")
ordering = ordering.split("\n").to_set
lists = lists.split("\n").map do |line|
  line.split(",").map(&:to_i)
end

def solve(lists, collect_valid_score, ordering)
  lists.map do |list|
    new_list = list.sort do |a, b|
      ordering.include?("#{a}|#{b}") ? -1 : 1
    end
    valid_order = new_list == list
    valid_order == collect_valid_score ? new_list[new_list.length/2] : 0
  end.sum
end

p solve(lists, true, ordering)
p solve(lists, false, ordering)

# 5452
# 4598
