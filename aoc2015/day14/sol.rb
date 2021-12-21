# 211220@18:02:00

data = File.open("input").read.split("\n").map do |row|
	row = row.strip.split(" ")
	# name, speed, time, rest
	[row[0], row[3].to_i, row[6].to_i, row[-2].to_i]
end

def dist(config, time)
	name, speed, boost_time, rest_time = config
	dist = 0
	while time > 0
		boost = [time, boost_time].min
		dist += speed * boost
		time -= boost
		break if time == 0
		rest = [time, rest_time].min
		time -= rest
	end
	dist
end

def race(configs, time)
	results = configs.map{|config|[dist(config, time), config]}.sort
	best_dist = results.last.first
	best_deers = results.filter{|rec|rec.first==best_dist}.map{|rec|rec.last.first}
	[best_dist, best_deers]
end

def part2(configs)
	scores = Hash.new 0
	2503.times do |time|
		race(configs, time+1)[1].each do |deer|
			scores[deer] += 1
		end
	end
	scores
end

p race(data, 2503)
# s1 08:00

p part2(data)
# s2 13:40