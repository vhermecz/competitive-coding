require 'set'

INPUT='test'
INPUT='input'

def maxes game
	steps = game.flatten(1)
	steps.group_by(&:last).map do |c, v|
		[c, v.map(&:first).max]
	end.to_h
end

data = File.read(INPUT).split("\n").map do |row|
	game_desc, sets = row.split(": ")
	_, game_num = game_desc.split(" ")
	[game_num.to_i, sets.split("; ").map do |reveals|
		reveals.split(", ").map do |reveal|
			count, color = reveal.split(" ")
			[count.to_i, color]
		end
	end]
end

part1 = data.map do |i, game|
	d = maxes(game)
	i if d['red'] <= 12 && d['green'] <= 13 && d['blue'] <= 14
end.compact.sum
p part1

part2 = data.map do |i, game|
	maxes(game).values.reduce{|a,b|a*b}
end.sum
p part2
