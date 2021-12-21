# 18:53:00

def compounds_to_h str
	str.split(", ").map{|r|r.split(": ").then{|r|[r.first, r.last.to_i]}}.to_h
end

data = File.open("input").read.split("\n").map do |row|
	compounds_to_h(row.strip.split(": ", 2).last)
end

hint = compounds_to_h("children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1")
$err_gt = ["cats", "trees"]
$err_lt = ["pomeranians", "goldfish"]

def matches1(memory, full)
	memory.each do |k,v|
		return false if full[k] != v
	end
	return true
end

def matches2(memory, full)
	memory.each do |k,v|
		return false if $err_gt.include?(k) && v <= full[k]
		return false if $err_lt.include?(k) && v >= full[k]
		return false if !$err_lt.include?(k) && !$err_gt.include?(k) && full[k] != v
	end
	return true
end



p data.each_with_index.filter{|val, idx|matches1(val, hint)}.first.last+1
p data.each_with_index.filter{|val, idx|matches2(val, hint)}.first.last+1

# 19:00:30 parsed
# 19:09:00 st1 - 103
# 19:15:15 st2 - 405
# 19:22:14 cleanup
