# 21:30-

$input = 33100000

def solve1
	max = 1e6.to_i
	house = [0]*max
	(1..max).each do |elf|
		(1..max).each do |i|
			break if i*elf >= max
			house[i*elf] += elf*10
		end
	end
	house.each_with_index.filter{|v|v.first>=$input}.first&.last
end
#p solve1
# 42:00

def solve2
	max = 1e6.to_i
	house = [0]*max
	(1..max).each do |elf|
		(1..50).each do |i|
			break if i*elf >= max
			house[i*elf] += elf*11
		end
	end
	house.each_with_index.filter{|v|v.first>=$input}.first&.last
end

p solve2
# 43:54