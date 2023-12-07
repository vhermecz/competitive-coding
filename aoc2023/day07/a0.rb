require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	hand, bid = row.split(" ")
	[hand, bid.to_i]
end

CARDS = "AKQJT98765432"
CARDS_ARR = CARDS.split ""
CARDS_PART2 = "AKQT98765432J"

def get_order hand
	[get_rank(hand)] + hand.split("").map{|v|CARDS.index(v)}
end

def unjoke hand
	hand_arr = hand.split("")
	hand_nojoke = hand_arr.filter{|v|v!='J'}
	c_joker = 5 - hand_nojoke.length
	return hand if c_joker == 0
	joke_pos = hand_arr.each_with_index.filter{|v, i|v=='J'}.map(&:last)
	jokes = CARDS_ARR.product(*(c_joker-1).times.map{CARDS_ARR})
	candidates = jokes.map do |joke|
		hand_cand = hand_arr.dup
		joke.zip(joke_pos).each do |card, pos|
			hand_cand[pos] = card
		end
		hand_cand.join("")
	end
	candidates.sort_by{|v|get_order(v)}.first
end

def get_rank hand
	counts = hand.split('').group_by{|a|a}.to_a.map{|v|v.last.length}
	return 1 if counts.max == 5
	return 2 if counts.max == 4
	return 3 if counts.max == 3 and counts.length == 2
	return 4 if counts.max == 3 and counts.length == 3
	return 5 if counts.filter{|v|v==2}.length == 2
	return 6 if counts.max == 2
	return 7
end

$joke_ranks = data.map do |hand, _|
	[hand, get_rank(unjoke(hand))]
end.to_h


def get_order_joke hand
	[$joke_ranks[hand]] + hand.split("").map{|v|CARDS_PART2.index(v)}
end

part1 = data.sort_by{|v|get_order(v[0])}.reverse.each_with_index.map do |v, i|
	v.last*(i+1)
end.sum
# solve
p part1

part2 = data.sort_by{|v|get_order_joke(v[0])}.reverse.each_with_index.map do |v, i|
	v.last*(i+1)
end.sum
p part2

#  7   00:18:41    769      0   00:50:28   2768      0

# 253036824 wrong @11:50
# 257270633 wrong @13:59 missed full-house vs three-of-a-kind
# 256181966 wrong @16:15 implement card-order (used ascii-order)
# 251545216 @18:47 ?

# part2
# 251023103 nope
# 250253918 nope @42:50 x
# 250599963 nope @49:30 joker just affects the rank
# 250384185 @50:30 change joker order
