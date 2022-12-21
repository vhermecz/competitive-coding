require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	var, expr = row.split(": ")
	expr = expr.split(" ")
	[var, expr]
end.to_h

def copy(data)
	data.to_a.map do |v|
		[v[0], v[1][0..]]
	end.to_h
end

def get(data, name)
	expr = data[name]
	return expr[0].to_i if expr.length == 1
	v1 = get(data, expr[0])
	v2 = get(data, expr[2])
	op = expr[1]
	if op == "+"
		v = v1+v2
	elsif op == "-"
		v = v1-v2
	elsif op == "*"
		v = v1*v2
	elsif op == "/"
		v = v1/v2
	end
	data[name] = [v]
	v
end

# solve
def solve1(data)
	get(copy(data), "root")
end

def part2(data, v)
	spec = copy(data)
	spec["root"][1] = "-"
	spec["humn"] = [v]
	get(spec, "root")
end

def solve2(data)
	n = 0
	while true
		v = part2(data, n)
		return n if v == 0
		while true
			nv = part2(data, n+1)
			return n+1 if nv == 0
			if nv != v
				n += nv/(v-nv)
				break
			end
			v = nv
			n += 1
		end
	end
end

p solve1(data)
p solve2(data)

# 6:30 87457751482938 301
# 34:24 3221245824363 773
# 55:50 proper solve part2
