#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |block|
	block.split("\n").map(&:to_i).sum
end

p data.max
p data.sort[-3..].sum
