require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT).split("\n").map do |line|
	line.split(" ")
end

$SCORE = {
	"A" => 1,
	"B" => 2,
	"C" => 3,
	"X" => 1, # loose
	"Y" => 2, # draw
	"Z" => 3, # win
}

def deduct_hand(data)
	data.map do |line|
		enemy = $SCORE[line[0]]
		hint = $SCORE[line[1]]
		hint_delta = hint - 2
		your = (((enemy - 1) + (hint_delta)) % 3) + 1
		[enemy, your].map{|v|(64+v).chr}  # map back to ABC
	end
end

def score(data)
	d1 = data.map do |line|
		enemy = $SCORE[line[0]]
		you = $SCORE[line[1]]
		score = ((you-enemy+1)%3)*3
		score + you
	end
end

p score(data).sum
p score(deduct_hand(data)).sum


# solve
# 3:44 start solving
# 8:52 14905 bad
# 11:36 17086 bad
# 12:34 15859 bad, so many ways to break
# 15:49 12679 6247th
# 20:31 14470 4743rd
