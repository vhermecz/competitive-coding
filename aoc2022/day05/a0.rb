require 'set'

#INPUT='test'
INPUT='input'

# read_input
d1,d2 = File.read(INPUT).split("\n\n")
d1 = d1.split("\n")
n_stack = (d1[0].length+1)/4
h_stack = d1.length - 1

p n_stack
stacks = []
n_stack.times do 
	stacks.append([])
end

h_stack.times do |r|
	n_stack.times do |c|
		v = d1[r][c*4+1]
		stacks[c].prepend(v) if v != ' '
	end
end

d2 = d2.split("\n").map do |row|
	row = row.split(" ")
	[row[1], row[3], row[5]].map(&:to_i)
end

d2.each do |step|
	tmp = []
	step[0].times do
		tmp.append(stacks[step[1]-1].pop())
	end
	step[0].times do
		stacks[step[2]-1].append(tmp.pop())
	end
end

p stacks

p(stacks.map do |stack|
	stack[-1]
end.join(""))

# solve
# 00:12:55 SVFDLGLWV 971
# 00:14:12 DCVTCVPCL 746
