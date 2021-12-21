# 18:14:00

data = File.open("input").read.split("\n").map do |row|
	name, ingr = row.strip.split(": ")
	ingr.split(", ").map{|i|i.split(" ").last.to_i} #then{|j|[j.first, j.last.to_i]}}
end

def split_value(total, n)
	(total+n-1).times.to_a.combination(n-1).map do |p|
		([-1] + p + [total+n-1]).each_cons(2).map{|a,b|b-a-1}
	end
end

def best(data, total, cal500)
	split_value(total, data.length).map do |values|
		score = data.first.length.times.map do |iprop|
			[values.length.times.map do |ivalue|
				data[ivalue][iprop]*values[ivalue]
			end.sum,0].max
		end
		(!cal500 || score[4]==500) ? score[0..-2].inject(1){|acc,i|acc*i} : 0
	end.flatten.max
end

p best(data, 100, false)
p best(data, 100, true)

# st1 18:38:40
#   missing negative=>0
# st2 18:40:20
# beauty 18:51:55
