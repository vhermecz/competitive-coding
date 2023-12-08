require 'set'

INPUT='test'
INPUT='input'

# read_input
instr, rules = File.read(INPUT).split("\n\n")
rules = rules.split("\n").map do |rule|
	from, tos = rule.split(" = ")
	[from, tos[1...-1].split(", ")]
end.to_h
instr = instr.split("").map{|step|step == 'L'?0:1}

# solve
step = 0
loc = "AAA"
while loc != 'ZZZ'
	loc = rules[loc][instr[step % instr.length]]
	step += 1
end
p step

starts = rules.keys.filter{|x|x[2]=='A'}
steps = starts.map do |loc|
	end_ = loc[...-1] + 'Z'
	step = 0
	while loc[2] != 'Z' || step % instr.length != 0
		loc = rules[loc][instr[step % instr.length]]
		step += 1
	end
	step
end
p steps.reduce(1, :lcm)

#  8   00:07:33   1275      0   00:19:18    659      0
# 15989
# 13830919117339
