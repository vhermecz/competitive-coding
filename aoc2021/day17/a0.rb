require 'set'

# test
#tx, ty = [20, 30], [-10, -5]
# input
tx, ty = [70, 96], [-179,-124]

maxy = 0
cnt = 0
(0..tx.last).each do |ivx|
	(ty.first..-ty.first).each do |ivy|
		vx, vy = ivx, ivy
		px, py = 0, 0
		besty = py
		while py >= ty[0] do
			px += vx
			py += vy
			vx -= vx/vx.abs rescue 0
			vy -= 1
			besty = [py, besty].max
			if px >= tx[0] and px <= tx[1] and py >= ty[0] and py <= ty[1]
				cnt += 1
				maxy = [maxy, besty].max
				break
			end
		end
	end
end

p maxy
p cnt

# 00:28:50   1792 - 15931
# 01:51:54   4884 - 2555
# 
# postmortem:
# - skipped analyzing what would be the valid range to search in
#   - missed the trivial 1 step throw cases
#   - was searching (10..61, -100..350) while solution was in (12..96, -179..178)
# - didn't realize after the maxy was accepted, that there is no point for looking for large ivy
#   - Was suspecting a tricky diophantine equation in the background
