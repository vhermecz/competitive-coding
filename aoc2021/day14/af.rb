require 'set'

INPUT='test'
#INPUT='input'

base = nil
data = {}
File.open( INPUT ) do |f|
	base = f.gets.strip
	f.gets
	data = f.map do |row|
		row.strip.split(" -> ")
	end.to_h
end

def mostleaststat(h)
	stat = h.to_a.map(&:reverse).sort.map(&:first)
	stat.last - stat.first
end

def mergecounts(x, y) =	x.merge(y){|_, a, b|a+b}

def solve(data, base, iter)
	state = data.keys.map do |key|
		[key, {key[0] => 1}]
	end.to_h
	state = iter.times.inject(state) do |state|
		data.map do |key, insert|
			[key, mergecounts(state[key[0]+insert], state[insert+key[1]])]
		end.to_h
	end
	counter = base.each_char.each_cons(2).inject({}) do |counter, pair|
		mergecounts(counter, state[pair.join])
	end
	counter[base[-1]] += 1
	mostleaststat(counter)
end

p solve(data, base, 10)
p solve(data, base, 40)
