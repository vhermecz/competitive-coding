require 'set'
data = File.open("input").read.split("\n").map{|row|row.strip}

def nice str
	return false unless (str.split("").filter{|c|!'aeiuo'.index(c).nil?}.length >= 3)
	return false unless str.split("").each_cons(2).any?{|a,b|a==b}
	return false if ['ab', 'cd', 'pq', 'xy'].any?{|bad|!str.index(bad).nil?}
	return true
end

p data.filter{|row|nice(row)}.length

def nice2 str
	return false unless str.split("").each_cons(2).to_set.any?{|a,b|!str.index(a+b, str.index(a+b)+2).nil?}
	return false unless str.split("").each_cons(3).any?{|a,b,c|a==c}
	return true
end

p data.filter{|row|nice2(row)}.length
