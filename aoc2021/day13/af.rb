require 'set'

INPUT='input'

conns = []
folds = []
File.open( INPUT ) do |f|
	while true do
		row = f.gets.strip
		break if row.empty?
		conns << row.split(",").map(&:to_i)
	end
	while true do
		row = f.gets.strip rescue ''
		break if row.empty?
		axis,value = row[11..].split("=")
		folds << [axis=='x'?0:1, value.to_i]
	end
end

folds.each do |axis, value|
	p axis, value
	p conns
	conns = conns.map do |conn|

		conn[axis] = value-(conn[axis]-value).abs
		conn
	end.to_set.to_a
	p conns
end

p conns

w = conns.map{|x|x[0]}.max + 1
h = conns.map{|x|x[1]}.max + 1

puts w, h
m = [' '] * w * h
conns.each do |x,y|
	m[w*y+x]='W'
end

h.times.each do |r|
	puts m[(r*w)..((r+1)*w-1)].join('')
end

#631