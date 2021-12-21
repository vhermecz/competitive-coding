require 'set'
# 19:22:50

data = File.open("input").read.split("\n").map{|r|r.strip.to_i}
total = 150

#data = [20, 15, 10, 5, 5]
#total = 25

def powerset(data)
	(0..(data.length)).map{|n|data.combination(n).to_a}.flatten(1)
end

data = data.sort
fills = powerset(data).filter{|c|c.sum==total}
p fills.length
min_container_num = fills.map{|f|f.length}.min
p fills.filter{|f|f.length==min_container_num}.length

# 10482070 - toohigh 19:26:20 (omg !=150 instead of ==150)
# 3690 - toohigh
# damn, should read the desc
# st1 19:28:50 - 654
# st2 19:33:35 - 57
# 19:42:20 - cleanup
# 	who, no powerset in ruby
# 	https://stackoverflow.com/questions/8533336/generate-a-powerset-of-a-set-without-keeping-a-stack-in-erlang-or-ruby
