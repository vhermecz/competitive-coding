require 'set'

#INPUT='test'
INPUT='input'

VAL = {
	"2" => 2,
	"1" => 1,
	"0" => 0,
	"-" => -1,
	"=" => -2,
}

def fw(x)
	l = x.length
	x.split("").each_with_index.map do |d, i|
		5**(l-i-1)*VAL[d]
	end.sum	
end

# read_input
data = File.read(INPUT).split("\n").map{|x|fw(x)}

def rev(num)
	res = ""
	while num!=0
		num += 2
		res += VAL.invert[num%5-2]
		num /= 5
	end
	res.reverse
end

# solve
print rev(data.sum)

# 6:00 30535047052797 (bug: SNAFU needed)
# 14:30 2=001=-2=--0212-22-2 461
# 14:34 xmas 390
