require 'set'

INPUT='test'
INPUT='input'

data = File.read(INPUT).strip.split(",")

def hash v
	v.split("").reduce(0){|s, n|((s+n.ord)*17)%256}
end

# solve
part1 = data.map{|v|hash v}.sum

state = 256.times.map{[]}
data.each do |instr|
	if instr.end_with? "-"
		name = instr[...-1]
		ibox = hash name
		state[ibox] = state[ibox].filter{|i|i[0] != name}
	else
		name, foc = instr.split("=")
		box = state[hash name]
		idx = box.index{|i|i[0]==name} || box.length
		box[idx] = [name, foc.to_i]
	end
end

part2 = state.each_with_index.map do |box, ibox|
	box.each_with_index.map do |item, iitem|
		(ibox+1)*(iitem+1)*item[1]
	end.sum
end.sum

p part1
p part2

#  15   00:04:11    823      0   00:17:34    638      0
# 515495
# 229349
