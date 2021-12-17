require 'set'

INPUT='test'
#INPUT='input'

# read_input
data = []
# File.open( INPUT ) do |f|
# 	while true do
# 		row = f.gets.strip
# 		break if row.empty?
# 		data << row.split(",").map(&:to_i)
# 	end
# end

#tx=[20, 30]
#ty=[-10, -5]

tx=[70, 96]
ty=[-179,-124]

px, py = [0, 0]

maxy = 0
cnt = [].to_set
steps = [].to_set
stepsh = Hash.new 
ysh = Hash.new 
# [[12, 96], [-179, 178]] - actual solution
# [[10, 61], [-100, 350]] - was searching
(12..13).each do |ivx|
	(3782..4182).each do |ivy|
		iv = [ivx, ivy]
		vx, vy = [ivx, ivy]
		#p iv
		step = 0
		px, py = [0, 0]
		besty = py
		while py >= ty[0] do
			#iterstart
			px += vx
			py += vy
			vx -= vx/vx.abs rescue 0
			vy -= 1
			step += 1
			#p [px, py, vx, vy]
			#iterend
			besty = [py, besty].max
			if px >= tx[0] and px <= tx[1] and py >= ty[0] and py <= ty[1]
				cnt << iv
				steps << step
				stepsh[ivx] = [].to_set if stepsh[ivx].nil?
				stepsh[ivx] << step
				ysh[ivx] = [].to_set if ysh[ivx].nil?
				ysh[ivx] << ivy
				p [iv, step, besty]
				if besty > maxy
					#p [iv, step, besty]
					maxy = besty			
				end
				next
				#maxy = [besty, maxy].max
			end
		end
	end
end

# p cnt
p [cnt.map{|p|p[0]}.minmax, cnt.map{|p|p[1]}.minmax]
p steps.minmax
p cnt.length
p stepsh
p ysh
# p maxy

# solve
# 28 bad
# 15931 (oops that is the maxy)
# 1043