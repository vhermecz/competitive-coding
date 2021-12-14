require 'set'

INPUT='test'
#INPUT='input'

# read_input
data = []
File.open( INPUT ) do |f|
	while true do
		row = f.gets.strip
		break if row.empty?
		data << row.split(",").map(&:to_i)
	end
end

# solve
