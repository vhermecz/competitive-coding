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

data["root"][1] = "="

def get(name)
	#p name
	expr = $spec[name]
	if expr.length == 1
		return expr[0].to_i 
	end
	v1 = get(expr[0])
	v2 = get(expr[2])
	op = expr[1]
	if op == "+"
		v = v1+v2
	elsif op == "-"
		v = v1-v2
	elsif op == "*"
		v = v1*v2
	elsif op == "/"
		v = v1/v2
	elsif op 
		v = v1 == v2
	end
	$spec[name] = [v]
	v
end

# solve
1000000.times do |v|
	v += (59078404896403 / 13) / 2
	v += (9044137600992/13)
	v += (30793309103046-28379346560301)/13
	v += (29023655110004-28379346560301)/13
	v += (28551318376629-28379346560301)/13
	v += (28425247399324-28379346560301)/13
	v += 12251353400/13
	v += 3269997497/13
	v += 872787500/13
	v += 232954644/13
	v += 62174606/13
	v += 16603509/13
	v += 4430595/13
	v += 1183481/13
	v += 315939/13
	v += 85046/13
	p v if v % 10000 == 0
	$spec = copy(data)
	$spec["humn"] = [v]
	res = get("root")
	p [v, res, get("prrg"), get("jntz"), get("prrg")-get("jntz")]
	if res
		print v, res
		exit
	end
end
#$spec = data
#print get("root")

# 6:30    301
# 34:24    773
