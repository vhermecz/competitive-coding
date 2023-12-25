require "matrix"

#INPUT='test'
INPUT='input'

class Hail
	attr_reader :p0, :v
	def initialize(p0, v)
		@p0 = p0
		@v = v
	end
end

# read_input
storm = File.read(INPUT).split("\n").map do |row|
	p, v = row.split(" @ ")
	p = p.split(", ").map(&:to_i)
	v = v.split(", ").map(&:to_i)
	Hail.new(Vector.[](*p), Vector.[](*v))
end

def distance a, b, t
	ap = a.p0 + t*a.v
	bp = b.p0 + t*b.v
	(ap-bp).magnitude
end

def distance_d a, b, t
	eps = 0.01
	(distance(a, b, t+eps)-distance(a, b, t-eps))/eps/2
end

def distance_dd a, b, t
	eps = 0.01
	(distance_d(a, b, t+eps)-distance_d(a, b, t-eps))/eps/2
end


def t_near2 a, b
	t = 0
	10.times do
#		p t
		t = t - distance_d(a, b, t)/distance_dd(a, b, t)
	end
	t
end

def t_near a, b
	t_low = -1
	t_low *= 2 while distance_d(a, b, t_low) >= 0
	t_high = 1
	t_high *= 2 while distance_d(a, b, t_high) <= 0
	while t_high - t_low > 0.0000001
		t_mid = (t_low + t_high)/2.0
		break if t_mid == t_low || t_mid == t_high  # resolution too small
		#p t_mid
		if distance_d(a, b, t_mid) > 0
			t_high = t_mid
		else
			t_low = t_mid
		end
	end
	t_low
end

dists = []
storm.combination(2).each do |a,b|
	p dists.length if dists.length % 1000 == 0
	dists << [distance(a,b,t_near(a, b)), t_near(a, b), a, b]
end

dists.sort[..10].each do |d|
	p d
end

# 3.38
p t_near(storm[0], storm[2])
