input = File.read("input").split("\n").map(&:to_i).reverse

def cansplit(rest, idx, value)
	return true if value == 0
	return false if value < 0
	return false if idx>=rest.length
	return cansplit(rest, idx+1, value-rest[idx]) || cansplit(rest, idx+1, value)
end

def solve3(input)
	target = input.sum / 3
	(1..).each do |n|
		sol = input.combination(n).map do |c|
			next if c.sum != target
			rest = input.filter{|v|!c.include?(v)}
			next if !cansplit(rest, 0, target)
			c.reduce{|a,b|a*b}
		end.compact.sort.first
		return sol if !sol.nil?
	end
end

def cansplit3(rest, idx, value1, value2, value3)
	return true if value1 == 0 && value2 == 0 && value3 == 0
	return false if value1 < 0 || value2 < 0 || value3 < 0
	return false if idx>=rest.length
	return cansplit3(rest, idx+1, value1-rest[idx], value2, value3) || cansplit3(rest, idx+1, value1, value2-rest[idx], value3) || cansplit3(rest, idx+1, value1, value2, value3-rest[idx])
end

def solve4(input)
	target = input.sum / 4
	(1..).each do |n|
		sol = input.combination(n).map do |c|
			next if c.sum != target
			rest = input.filter{|v|!c.include?(v)}
			next if !cansplit3(rest, 0, target, target, target)
			c.reduce{|a,b|a*b}
		end.compact.sort.first
		return sol if !sol.nil?
	end
end

p solve3(input)  # 11846773891
p solve4(input)  # 80393059
