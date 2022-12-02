require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
	line.split(" ")
end

score = {
	"A" => 1,
	"B" => 2,
	"C" => 3,
	"X" => 1, # loose
	"Y" => 2, # draw
	"Z" => 3, # win
}

data = data.map do |line|
	e = score[line[0]]
	y = score[line[1]]

	[(64+e).chr, (65 +(((e - 1) + (y - 2)) % 3)).chr]
end

p data

d1 = data.map do |line|
	e = score[line[0]]
	y = score[line[1]]

	s = if (y==3 and e==2) or(y==2 and e==1) or (y==1 and e==3)
		6
	elsif y == e
		3
	else
		0
	end
	s + y
end

p d1
p d1.sum

# solve
# 3:44 start solving
# 8:52 14905 bad
# 11:36 17086 bad
# 12:34 15859 bad, so many ways to break
# 15:49 12679 6247th
# 20:31 14470 4743rd