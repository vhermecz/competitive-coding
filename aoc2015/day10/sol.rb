def iter str
	res = []
	last = nil
	cnt = 0
	(str.split("")+[nil]).each do |c|
		if c == last
			cnt += 1
		else
			if !last.nil?
				res << cnt.to_s
				res << last
			end
			cnt = 1
			last = c
		end
	end
	res.join("")
end

data = "1113122113"
40.times do
	data = iter(data)
end
p data.length
10.times do
	data = iter(data)
end
p data.length

# INTERESTING DP
