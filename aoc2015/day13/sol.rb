# 211220@17:47
require 'set'

data = File.open("input").read.split("\n").map do |row|
	row = row.strip.split(" ")
	[[row[0], row[-1][0..-2]], (row[2]=="lose"?-1:1)*row[3].to_i]
end.to_h

def score data
	data.keys.flatten.to_set.to_a.permutation.map do |order|
		(order + [order[0]]).each_cons(2).map{|a,b|data[[a,b]]+data[[b,a]]}.sum
	end.max
end

p score(data)
# 1star @17:55:48

data.keys.flatten.to_set.each do |person|
	data[[person, "Vajk"]] = 0
	data[["Vajk", person]] = 0
end

p score(data)
# 1star @17:57:47
