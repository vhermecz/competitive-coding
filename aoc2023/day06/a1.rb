require 'set'

#INPUT='test'
INPUT='input'

def solve_quadratic_original time, dist
	time.times.map do |j|
		speed = j
		(time-j)*speed
	end.filter{|v|v>dist}.length
end

def solve_quadratic_wordy time, dist
	# x*(t-x) > d
	# -x2 + tx - d > 0
	a = -1
	b = time
	c = -dist

	center = -b / 2.0 / a
	delta = (b*b - 4*a*c)**0.5 / 2.0

	from = center - delta
	to = center + delta
	(to.ceil - from.floor - 1).to_i
end

def solve_quadratic t, s
	c = t / 2.0
	d = (t**2 - 4*s)**0.5 / 2.0
	((c+d).ceil - (c-d).floor - 1).to_i
end

times, distances = File.read(INPUT).split("\n").map do |row|
	row.split(" ")[1..].map(&:to_i)
end

# solve
p times.zip(distances).map{|t,d|solve_quadratic(t, d)}.reduce{|a,b|a*b}
time = times.map(&:to_s).join().to_i
dist = distances.map(&:to_s).join().to_i
p solve_quadratic(time, dist)

#  6   00:05:35    691      0   00:08:37    753      0
# 211904
# 43364472
