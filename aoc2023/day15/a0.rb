require 'set'

INPUT='test'
INPUT='input'

data = File.read(INPUT).strip.split(",")

def hash v
	curr=0
	v.split("").each do |c|
		curr += c.ord
		curr = (curr*17) % 256
	end
	curr
end

part1 = data.map do |v|
	hash v
end

state = 256.times.map do
	[]
end

data.each do |instr|
	if instr.split("").last == "-"
		name = instr[...-1]
		box = hash name
		state[box] = state[box].filter{|i|i[0] != name}
	else
		name, foc = instr.split("=")
		foc = foc.to_i
		box = hash name
		idx = state[box].index{|i|i[0]==name}
		if idx.nil?
			state[box] << [name, foc]
		else
			state[box][idx] = [name, foc]
		end
	end
end

part2 = state.each_with_index.map do |vbox, bidx|
	vbox.each_with_index.map do |item, iidx|
		(bidx+1)*(iidx+1)*item[1]
	end.sum
end.sum

# solve
p part1
p part2

#  15   00:04:11    823      0   00:17:34    638      0
# 515495
# 229349
