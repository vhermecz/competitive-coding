require 'set'

#INPUT='test'
INPUT='input'

# read_input
base = nil
$data = {}
File.open( INPUT ) do |f|
	base = f.gets.strip
	f.gets
	while true do
		row = f.gets&.strip
		break if row.nil? or row.empty?
		pair, insert = row.split(" -> ")
		$data[pair] = insert
	end
end

realbase=base
counter = {}
10.times do 
	nbase = ""
	(base.length-1).times do |idx|
		pair = base[idx..(idx+1)]
		counter[pair] = (counter[pair] || 0) + 1
		nbase += base[idx] + $data[pair]
	end
	nbase += base[-1]
	base = nbase
end


p counter.length

p base.split('').tally
p counter

stat = counter.to_a.map{|x,y|[y,x]}.sort
p stat[-1][0]-stat[0][0]

def mergecounts(x, y)
	(x.keys.to_set + y.keys).map do |key|
		[key, (x[key]||0)+(y[key]||0)]
	end.to_h
end


# solve
$cache = {}
def basestat(pair, iter)
	if $cache[[pair, iter]].nil?
		res = if iter == 1
			(pair[0] + $data[pair]).split('').tally
		else
			x = pair[0] + $data[pair] + pair[1]
			mergecounts(basestat(x[0..1], iter-1), basestat(x[1..2], iter-1))
		end
		$cache[[pair, iter]] = res
	else
		$cache[[pair, iter]]
	end
end

counter = {}
(realbase.length-1).times do |idx|
	pair = realbase[idx..(idx+1)]
	counter = mergecounts(counter, basestat(pair, 40))
end
counter[realbase[-1]]+=1
#p $cache
#p counter
stat = counter.to_a.map{|x,y|[y,x]}.sort
p stat[-1][0]-stat[0][0]
