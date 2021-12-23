require 'set'

#INPUT='test2'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	state, size = row.strip.split(" ")
	[
		state == "on",
		size.split(",").map{|dim|dim.split("=").map{|mm|mm.split("..").map(&:to_i)}.last},
	]
end

data = data.map do |desc|
	[desc.first ? 1:0] + desc.last.map{|(lo,hi)|[lo,hi+1]}
end

def limiter(seq, limit)
	return seq unless limit
	seq1, out1 = seq.partition{|i|i>-50}
	seq2, out2 = seq1.partition{|i|i<51}
	[[*out1, -50].max] + seq2 + [[*out2, 51].min]
end

def solve(data, limit)
	return 0 if data.empty?
	return data.last.first if data.first.length == 1
	limiter(data.map(&:last).flatten.uniq.sort, limit).each_cons(2).map do |st, en|
		(en-st)*solve(data.filter{|d|d.last[0]<=st && en <= d.last[1]}.map{|d|d[0..-2]}, limit)
	end.sum
end

p solve(data, true)
p solve(data, false)

#star1 580810				test2=590784
#star2 1265621119006734		test2=39769202357779
