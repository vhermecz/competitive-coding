#19:27:00
#19:32:20 - reader ready (Learned about `split().then do` vs `split() do`)
# break
#19:33:20 - cont
#19:52:30 - star1 - omg

rules, molec = File.read("input").split("\n\n").then do |(rules, molec)|
	[
		rules.split("\n").map{|row|row.strip.split(" => ")},
		molec.strip
	]
end

def grow(rules, molec)
	rules.map do |from, to|
		molec.gsub(from).map do |x|
			r = molec[0..-1]
			r[Regexp.last_match.offset(0).first, from.length] = to
			r
		end
	end.flatten(1).uniq
end

p grow(rules, molec).length

# fail 19:58:15
# step = 0
# bin = rules.filter{|k,v|k=='e'}.map{|k,v|v}
# while !bin.include? molec
# 	p [step, bin.length]
# 	bin = bin.map{|cand|grow(rules, cand)}.flatten(1)
# 	step+=1
# 	#break if step==4
# end
# p step

def reduce(sentence, rules)
	step = 0
	while sentence != 'e'
		rules.each do |k,v|
			pos = sentence.index(v)
			next if pos.nil?
			sentence[pos,v.length]=k
			step += 1
		end
	end
	step
end

p reduce(molec, rules)
