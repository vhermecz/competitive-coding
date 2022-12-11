require 'set'

# INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |monkey|
	monkey = monkey.split("\n").map{|i|i.strip.split(": ")[-1].split(" ")}
	{
		:items => monkey[1].map{|i|i[0..-1].to_i},
		:xform_op => monkey[2][-2],
		:xform_num => monkey[2][-1],
		:div => monkey[3][-1].to_i,
		:tmon => monkey[4][-1].to_i,
		:fmon => monkey[5][-1].to_i,
		:cnt => 0,
	}
end

def xform_calc(mon, old)
	if mon[:xform_num] == "old"
		n = old
	else
		n = mon[:xform_num].to_i
	end
	if mon[:xform_op] == "+"
		n = old + n
	else
		n = old * n
	end
	n	
end

# solve
def solver(data, itercnt, worrydiv)
	data = Marshal.load(Marshal.dump(data))
	modder = data.map{|m|m[:div]}.inject(:*)
	itercnt.times do |t|
		data.each do |mon|
			mon[:cnt] += mon[:items].length
			until mon[:items].empty? do
				item = mon[:items].shift
				item = (xform_calc(mon, item) % modder) / worrydiv
				target = (item % mon[:div] == 0) ? mon[:tmon] : mon[:fmon]
				data[target][:items] << item
			end
		end
	end
	inspc = data.map{|m|m[:cnt]}.sort
	inspc[-1]*inspc[-2]
end

p solver(data, 20, 3)
p solver(data, 10000, 1)

# 00:24:29 56595 990
# 00:39:26 15693274740 1213
