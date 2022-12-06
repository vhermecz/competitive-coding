require 'set'

#INPUT='test'
INPUT='input'

data = File.read(INPUT)

def solve(data, n)
	data.length.times.each do |i|
		if data[i-n+1..i].chars.to_set.length == n
			return i+1
		end
	end
end

p solve(data, 4)
p solve(data, 14)

# solve
# 3:00 1848 bad (obo: idx-1)
# 4:00 1850 1212
# 6:24 2480 bad (obo: 14 unique in 15)
# 7:24 2823 2803
