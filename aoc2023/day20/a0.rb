require 'set'

INPUT='test'
INPUT='input'

# read_input
config = File.read(INPUT).split("\n").map do |row|
	node, targets = row.split(" -> ")
	targets = targets.split(", ")
	type = nil
	if node[0] != "b"
		type = node[0]
		node = node[1..]
	end
	[node, [type, targets]]
end.to_h

LOW = 0
HIGH = 1

def init_state config
	inputs = {}
	config.entries.each do |from, conf|
		conf[1].each do |to|
			(inputs[to] ||= []) << from
		end
	end
	state = config.entries.map do |key, conf|
		st = {}
		if conf[0] == '%'
			st['state'] = LOW
		elsif conf[0] == '&'
			inputs[key].each do |inp|
				st[inp] = LOW
			end
		end
		[key, st]
	end.to_h
end

def simulate config, state, stat, cnt
	signals = []
	signals << ['button', LOW, 'broadcaster']
	while !signals.empty?
		source, level, target = signals.shift
		stat[level] += 1
		stat['win'][source] = cnt if target == 'vd' && level == 1 && stat['win'][source].nil?
		next if config[target].nil?
		olevel = level
		if config[target][0] == '%'
			if level == LOW
				olevel = HIGH - (state[target]['state'] || LOW)
				state[target]['state'] = olevel
			else
				olevel = nil
			end
		elsif config[target][0] == '&'
			state[target][source] = level
			olevel = state[target].values.map{|v|v==HIGH}.all? ? LOW : HIGH
		end
		config[target][1].each do |ntarget|
			signals << [target, olevel, ntarget]
		end if !olevel.nil?
	end
end

# solve
state = init_state config
stat = {LOW=>0, HIGH=>0 , 'win'=>{}}
1000.times do 
	simulate config, state, stat, 0
end
p stat[LOW]*stat[HIGH]

state = init_state config
stat = {LOW=>0, HIGH=>0 , 'win'=>{}}
cnt = 0
while stat['win'].length < 4
	cnt += 1
	simulate config, state, stat, cnt
end
p stat['win'].values.reduce{|a,b|a*b}

#  20   00:46:21    817      0   01:20:33    800      0
# 788848550
# 228300182686739
