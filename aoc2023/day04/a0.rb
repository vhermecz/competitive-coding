require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	_, nums = row.split(": ")
	wins, haves = nums.split(" | ")
	[wins.strip.split(" ").map(&:to_i), haves.strip.split(" ").map(&:to_i)]
end

# solve
scores = data.map do |wins, haves|
	common = (haves.to_set & wins.to_set).length
	if common == 0
		0
	else
		2**(common-1)
	end
end
p scores.sum

copies = data.length.times.map do 1 end
counts = data.each_with_index.map do |details, idx|
	wins, haves = details
	p [idx, [wins, haves]]
	common = (haves.to_set & wins.to_set).length
	common.times.each do |i|
		copies[idx+i+1] += copies[idx]
	end
	copies[idx]
end
p counts.sum

#  4   00:04:36    535      0   00:12:19    682      0