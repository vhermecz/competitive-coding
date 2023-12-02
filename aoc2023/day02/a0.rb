require 'set'

INPUT='test'
INPUT='input'

def valid_step step
	count, color = step
	return false if color == 'red' and count > 12
	return false if color == 'green' and count > 13
	return false if color == 'blue' and count > 14
	return true
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
	steps = game.flatten(1)
	i if steps.all?{|step|valid_step step}
end.compact.sum
p part1

part2 = data.map do |i, game|
	steps = game.flatten(1)
	min_counts = {}
	steps.each do |step|
		count, color = step
		min_counts[color] = [min_counts[color] || count, count].max
	end
	a, b, c = min_counts.values
	a*b*c
end.sum
p part2

# started with 6 min delay, damn alarm on damn new phone, damn
# 2   00:21:22  4789      0   00:25:35  4190      0
