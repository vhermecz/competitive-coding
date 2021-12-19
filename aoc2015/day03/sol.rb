require 'set'

def solve(nav)
	x,y = [0,0]
	gifts = Hash.new 0
	gifts[[x,y]] += 1
	nav.each do |op|
		if op == "<"
			x-=1
		elsif op == ">"
			x+=1
		elsif op == "^"
			y-=1
		else
			y+=1
		end
		gifts[[x,y]] += 1
	end
	gifts.keys.to_set
end

nav = File.open("input").read.split("")
p solve(nav).length

s,r = nav.partition.each_with_index{ |el, i| i.even? }
p (solve(s)|solve(r)).length