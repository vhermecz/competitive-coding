require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map{|r|r.split(" ")}

# solve
signalx = [1]
data.each do |instr|
	signalx << signalx.last
	signalx << signalx.last + instr[1].to_i if instr.first == "addx"
end

part1 = [20, 60, 100, 140, 180, 220].map{|cnt|signalx[cnt-1]*cnt}.sum

part2 = 240.times.map{|idx|(signalx[idx]-idx%40).abs < 2 ? "#" : "."}

p part1
part2.each_slice(40).map(&:join).each do |row|
	puts(row)
end

# 11:49:00 start
# 11:56:40 12460
# 12:05:00 EZFPRAKL
