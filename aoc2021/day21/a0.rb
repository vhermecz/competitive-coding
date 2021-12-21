require 'set'

#p1, p2 = 4, 8  # test
p1, p2 = 9, 3  # input

def base1mod(v, mod)
	(v-1)%mod+1
end

def solve1(p1, p2)
	s1, s2 = 0, 0

	d = 1
	cnt = 0

	def throw3(d)
		[((d+3)-1)%100+1, [d, d+1, d+2].map{|x|(x-1)%100+1}.sum]
	end

	while true
		d, pt = throw3(d)
		cnt += 3
		p1 = base1mod(p1 + pt, 10)
		s1 += p1
		break if s1 >= 1000
		d, pt = throw3(d)
		cnt += 3
		p2 = base1mod(p2 + pt, 10)
		s2 += p2
		break if s2 >= 1000
	end
	[s1, s2].sort.first*cnt
end

p solve1(p1,p2)

# solve2

def solve2(p1,p2)
	throw3cnt = (1..3).to_a.product(*[(1..3).to_a]*2).map(&:sum).tally
	wins = [0, 0]
	state = {[p1, 0, p2, 0]=>1}
	round = 0
	while !state.empty?
		nstate = Hash.new 0
		throw3cnt.each do |value, times|
			state.each do |lstate, occcnt|
				pos, score = lstate[round*2,2]
				pos = base1mod(pos + value, 10)
				score += pos
				if round==0
					nstate[[pos, score] + lstate[2,2]] += occcnt * times
				else
					nstate[lstate[0,2] + [pos, score]] += occcnt * times
				end
			end
		end
		state = nstate
		statewins, state = state.partition{|lstate,c|lstate[round*2+1]>=21}.map(&:to_h)
		wins[round] += statewins.values.sum
		round = (round + 1) % 2
	end
	wins.sort.last
end

p solve2(p1, p2)

# 00:10:51    808 - 1073709
# 00:42:58    787 - 148747830493442
