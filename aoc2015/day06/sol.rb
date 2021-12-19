data = File.open("input").read.split("\n").map do |row|
	cmd, pstart, _, pend = row.strip.gsub('turn ', 'turn').split " "
	pstart = pstart.split(",").map(&:to_i)
	pend = pend.split(",").map(&:to_i)
	[cmd, pstart, pend]
end

m = [false] * 1000 * 1000
data.each do |cmd, ps, pe|
	(ps[0]..pe[0]).each do |x|
		(ps[1]..pe[1]).each do |y|
			if cmd=='turnoff'
				m[y*1000+x] = false
			elsif cmd=='turnon'
				m[y*1000+x] = true
			else
				m[y*1000+x] = !m[y*1000+x]
			end
		end
	end
end
p m.tally[true]

m = [0] * 1000 * 1000
data.each do |cmd, ps, pe|
	(ps[0]..pe[0]).each do |x|
		(ps[1]..pe[1]).each do |y|
			if cmd=='turnoff'
				m[y*1000+x] = [0, m[y*1000+x]-1].max
			elsif cmd=='turnon'
				m[y*1000+x] += 1
			else
				m[y*1000+x] += 2
			end
		end
	end
end

p m.sum