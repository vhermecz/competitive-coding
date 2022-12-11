require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |monkey|
	monkey = monkey.split("\n").map{|i|i.strip.split(": ")}
	items = monkey[1][1].split(", ").map(&:to_i)
	xform = monkey[2][1]
	div = monkey[3][1].split(" ")[-1].to_i
	tmon = monkey[4][1].split(" ")[-1].to_i
	fmon = monkey[5][1].split(" ")[-1].to_i
	mon = {
		"items": items,
		"xform": xform,
		"div": div,
		"tmon": tmon,
		"fmon": fmon,
	}
	mon
end

inspc = [0] * data.length

def xform_calc(xform, old)
	xform_op = xform.split(" ")[-2]
	xform_num = xform.split(" ")[-1]
	if xform_num == "old"
		n = old
	else
		n = xform_num.to_i
	end
	if xform_op == "+"
		n = old + n
	else
		n = old * n
	end
	n	
end

p data
# solve

modder = data.map{|m|m[:div]}.inject(:*)

10000.times do |t|
	data.length.times do |midx|
		mon = data[midx]
		#p ["MON", midx]
		inspc[midx] += mon[:items].length
		mon[:items].length.times do
			item = mon[:items].shift
			#p item
			item = xform_calc(mon[:xform], item) % modder
			#p item
			if item % mon[:div] == 0
				#p ["TRU", mon[:tmon]]
				data[mon[:tmon]][:items] << item
			else
				#p ["FAL", mon[:fmon]]
				data[mon[:fmon]][:items] << item
			end
		end
	end
	# p t
	# if t < 4
	# 	data.length.times do |midx|
	# 		p data[midx][:items]
	# 	end
	# end
	p inspc if [0,19].include? t
end

p inspc

p inspc.sort[-1]*inspc.sort[-2]

# 00:24:29 2713310158 990
# 00:39:26 15693274740 1213
