require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.split(" ")
	row[1] = row[1].to_i if row.length > 1
	row
end

signalx = [1]

data.each do |instr|
	if instr.first == "addx"
		signalx << signalx.last
		signalx << signalx.last + instr[1]
	elsif instr.first == "noop"
		signalx << signalx.last
	end
end

e = [20, 60, 100, 140, 180, 220].map do |cnt|
	signalx[cnt-1]*cnt
end

screen = []

240.times do |idx|
	pos = idx % 40
	if (signalx[idx]-pos).abs < 2
		screen << "#"
	else
		screen << "."
	end
end


# solve
p e.sum
screen.each_slice(40).map(&:join).each do |row|
	puts(row)
end

# 11:49:00 start
# 11:56:40 12460
# 12:05:00 EZFPRAKL
