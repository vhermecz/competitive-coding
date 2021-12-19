input = "cqjxjnds"

def incr str
	data = str.split("")
	pos = data.length - 1
	while pos >= 0
		data[pos] = ((((data[pos].ord+1) & 31)-1)%26+97).chr
		break unless data[pos] == 'a'
		pos -= 1
	end
	data.join ""
end

def valid str
	return false if str.index("o") || str.index("i") || str.index("l")
	return false unless str.split("").each_cons(3).any?{|a,b,c|a.ord+1==b.ord && b.ord+1==c.ord}
	idx = str.split("").each_cons(2).each_with_index do |pair,idx|
		break idx if pair[0]==pair[1]
	end
	return false if idx.nil?
	return false unless str[idx+2..].split("").each_cons(2).any?{|a,b|a==b}
	return true  # argh, missed this, cost 30 min
end

def nextvalid str
	str = incr str
	str = incr str while !valid str
	str
end

input = nextvalid input
p input
input = nextvalid input
p input
