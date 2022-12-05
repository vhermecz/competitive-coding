require 'set'

#INPUT='test'
INPUT='input'

# read_input
def parse(fname)
	d1,d2 = File.read(fname).split("\n\n")
	d1 = d1.split("\n")
	n_stack = (d1[0].length+1)/4
	h_stack = d1.length - 1
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
	steps = d2.split("\n").map do |row|
		row = row.split(" ")
		[row[1], row[3], row[5]].map(&:to_i)
	end
	[stacks, steps]
end

# solve
def apply(stacks, steps, rev: true)
	stacks = Marshal.load(Marshal.dump(stacks))
	steps.each do |step|
		tmp = stacks[step[1]-1].pop(step[0])
		tmp = tmp.reverse() if rev
		stacks[step[2]-1].append(*tmp)
	end
	stacks
end
def top_signature(stacks)
	stacks.map do |stack|
		stack[-1]
	end.join("")
end
stacks, steps = parse(INPUT)

p top_signature apply(stacks, steps)
p top_signature apply(stacks, steps, rev: false)

# 00:12:55 SVFDLGLWV 971
# 00:14:12 DCVTCVPCL 746
