require 'set'

INPUT='test'
INPUT='input'

times, distances = File.read(INPUT).split("\n").map do |row|
	row.split(" ")[1..].map(&:to_i)
end

part1 = times.length.times.map do |i|
	time = times[i]
	dist = distances[i]
	time.times.map do |j|
		speed = j
		(time-j)*speed
	end.filter{|v|v>dist}.length
end

# solve
p part1.reduce{|a,b|a*b}

time = times.map(&:to_s).join().to_i
dist = distances.map(&:to_s).join().to_i
part2 = time.times.map do |j|
	speed = j
	(time-j)*speed
end.filter{|v|v>dist}.length

p part2

#  6   00:05:35    691      0   00:08:37    753      0
# 211904
# 43364472
