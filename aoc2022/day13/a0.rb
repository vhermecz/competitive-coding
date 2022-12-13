require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |pair|
	pair.split("\n").map{|v|eval(v)}
end

def compare(a, b)
	return -1 if a.nil?
	return 1 if b.nil?
	return a <=> b if a.class == Integer and b.class == Integer
    a = [a] if a.class == Integer
	b = [b] if b.class == Integer
	a += [nil] * [b.length-a.length, 0].max  # damn, lost some time here
	a.zip(b).each do |av, bv|
		r = compare(av, bv)
		return r if r != 0
	end
	0
end

# solve
p data.each_with_index.filter{|v, idx|compare(v[0],v[1])<0}.map{|v,i|i+1}.sum

divs = [[[2]], [[6]]]
data2 = (data.flatten(1) + divs).sort{|a,b|compare(a,b)}
p data2.each_with_index.filter{|v, idx|divs.include? v}.map{|v,i|i+1}.inject(:*)

# 00:19:29 4734 896
# 00:23:26 21836 676
