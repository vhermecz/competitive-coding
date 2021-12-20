require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = []
enh, data = File.open(INPUT).read.split("\n\n")
enh = enh.strip
data = data.split("\n").map{|r|r.strip.split("")}

def debug(data)
	data.each do |r|
		puts r.join
	end
end

def grow(data, out)
	nw = data.first.length + 2
	[nw.times.map{out}] + data.map{|r|[out]+r[0..-1]+[out]} + [nw.times.map{out}]
end

def enhance(data, enh, out)
	data = grow(grow(data, out), out)
	w = data.first.length
	h = data.length
	ndata = h.times.map do |y|
		w.times.map do |x|
			val = (-1..1).map do |dy|
				(-1..1).map do |dx|
					data[y+dy][x+dx] rescue out
				end
			end.flatten(1).join("").gsub("#", "1").gsub(".", "0").to_i(2)
			enh[val]
		end
	end
	ndata
end
# solve

25.times do |i|
	data = enhance(data, enh, ".")
	data = enhance(data, enh, "#")
	data[-1][-1] = '.'
	p data.flatten.tally["#"] if i==0 || i==24
end

# 00:32:49    795 - 5419
# 00:36:35    778 - 17325

# 5447 bad
# 6217 bad
# 5420 bad
# 5419? (why the corner?)
# 19074 bad
# 17325 good (guess)
