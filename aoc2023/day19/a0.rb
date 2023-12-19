require 'set'

#INPUT='test'
INPUT='input'

# read_input
rules, parts = File.read(INPUT).split("\n\n")

rules = rules.split("\n").map do |rule|
	name, conditions = rule[...-1].split("{")
	conditions = conditions.split(",").map do |condition|
		pieces = condition.split(":")
		condition = nil
		target = pieces.last.to_sym
		if pieces.length > 1
			condition = [pieces.first[0].to_sym, pieces.first[1].to_sym, pieces.first[2..].to_i]
		end
		[condition, target]
	end
	[name.to_sym, conditions]
end.to_h

parts = parts.split("\n").map do |part|
	part[1...-1].split(",").map do |assignment|
		var, val = assignment.split("=")
		[var.to_sym, val.to_i]
	end.to_h
end

# solve
def eval_rule part, rule
	rule.each do |cmd|
		return cmd.last if cmd.first.nil?
		field, op, tgt = cmd.first
		return cmd.last if op == :< && part[field] < tgt
		return cmd.last if op == :> && part[field] > tgt
	end
end

def eval part, rules
	cmd = :in
	while ![:A, :R].include?(cmd)
		cmd = eval_rule(part, rules[cmd])
	end
	cmd == :A
end

def eval_part2 region, rules, cmd, idx
	volume = region.values.map{|v|[0, v.last-v.first+1].max}.inject(:*)
	return 0 if cmd == :R || volume == 0
	return volume if cmd == :A
	rule = rules[cmd][idx]
	return eval_part2(region, rules, rule.last, 0) if rule.first.nil?
	field, op, tgt = rule.first
	if op == :<
		region_a = region.dup
		region_a[field] = [region_a[field].first, tgt-1]
		region_b = region.dup
		region_b[field] = [tgt, region_b[field].last]
		return eval_part2(region_a, rules, rule.last, 0) + eval_part2(region_b, rules, cmd, idx+1) 
	else
		region_a = region.dup
		region_a[field] = [tgt+1, region_a[field].last]
		region_b = region.dup
		region_b[field] =  [region_b[field].first, tgt]
		return eval_part2(region_a, rules, rule.last, 0) + eval_part2(region_b, rules, cmd, idx+1) 
	end
end

p parts.filter{|p|eval(p, rules)}.map{|p|p.values}.flatten.sum

start = {
	x: [1, 4000],
	m: [1, 4000],
	a: [1, 4000],
	s: [1, 4000],
}
p eval_part2(start, rules, :in, 0)

#  19   00:20:58    798      0   00:37:58    342      0
# 418498
# 123331556462603
