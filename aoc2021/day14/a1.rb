require 'set'

INPUT='test'
#INPUT='input'

# read_input
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

def solve1(data, base, iter)
	base = iter.times.inject(base) do |base|
		(
			base.each_char.each_cons(2).map do |pair|
				pair[0] + data[pair.join]
			end + [
				base[-1]
			]
		).join
	end
	mostleaststat(base.split('').tally)
end

def solve2(data, base, iter)
	def basestat(pair, iter, cache, data)
		cache[[pair, iter]] ||= if iter == 0
			{pair[0] => 1}
		else
			x = pair[0] + data[pair] + pair[1]
			mergecounts(
				basestat(x[0,2], iter-1, cache, data),
				basestat(x[1,2], iter-1, cache, data)
			)
		end
	end
	cache = {}
	counter = base.each_char.each_cons(2).inject({}) do |counter, pair|
		mergecounts(counter, basestat(pair.join, iter, cache, data))
	end
	counter[base[-1]]+=1
	mostleaststat(counter)
end

def solve2dp(data, base, iter)
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

p solve1(data, base, 10)
p solve2dp(data, base, 40)
