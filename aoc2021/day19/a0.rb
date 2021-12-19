require 'set'

#INPUT='test'
INPUT='input'

# read_input
def read_input
	data = []
	File.open( INPUT ) do |f|
		while true do
			f.gets
			scanner = []
			while true do
				row = f.gets&.strip
				if row.nil?
					data << scanner
					return data
				end
				break if row.empty?
				scanner << row.split(",").map(&:to_i)
			end
			data << scanner
		end
	end
end

def sgn(x)
	x<=>0
end

# rotations
def rot90(orient, rotax)
	[-orient[(rotax+2)%3], orient[(rotax+1)%3], orient[rotax]]
end

def genax
	base = [[1,2,3]].to_set
	7.times.each do |ax|
		base.merge(base.map do |v|
			3.times.map do
				rot90(v, ax%3)
			end
		end.flatten(1))
	end
	base
end

#rotate p by tf
def tf_base(p, tf)
	3.times.map do |ax|
		p[tf[ax].abs-1]*sgn(tf[ax])
	end
end

def transform_points(points, tf)
	r0 = tf[0].abs-1
	s0 = sgn(tf[0])
	r1 = tf[1].abs-1
	s1 = sgn(tf[1])
	r2 = tf[2].abs-1
	s2 = sgn(tf[2])
	points.map do |p|
		[p[r0]*s0, p[r1]*s1, p[r2]*s2]
	end
end

def translate_points(points, tl)
	points.map{|p|[p[0]+tl[0], p[1]+tl[1], p[2]+tl[2]]}
end

def find_patch(coll, datasets, rotations)
	coll_set = coll.to_set
	datasets.length.times do |dataset_idx|
		rotations.each do |tf|
			dataset = transform_points(datasets[dataset_idx], tf)
			coll.each do |p1|
				dataset.each do |p2|
					tl = [p1[0]-p2[0], p1[1]-p2[1], p1[2]-p2[2]]
					neu_tl = translate_points(dataset, tl)
					if (coll_set & neu_tl).length >= 12
						return [dataset_idx, tf, tl]
					end
				end
			end
		end
	end
	nil
end

rotations = genax
datasets = read_input
coll = datasets.pop
datasets.reverse!
cnt = 0
spos = [[0,0,0]]
while !datasets.empty?
	p [cnt, coll.length, datasets.length]
	idx, tf, tl = find_patch(coll, datasets, rotations)
	spos << tl
	dataset = transform_points(datasets[idx], tf)
	dataset = translate_points(dataset, tl)
	coll = (coll.to_set | dataset).to_a
	datasets.delete_at(idx)
	cnt += 1
end

p coll.length

maxman = spos.combination(2).map do |p1,p2|
	3.times.map{|ax|(p1[ax]-p2[ax]).abs}.sum
end.max
p maxman

# 01:45:28    651 - 496
# 01:49:35    559 - 14478
#
# NOTE: Pretty slow, runs in about 15minutes, BF is not ideal for Ruby :P
# ERROR: Got the result once, but the autoreload ate it
# 	Probably should save STDOUT into a log

# Timeline
#  0:00 6am
#  0:30 start reading
#  8:40 start formulating solution
# 14:35 start working on rotations
# 27:23 have the 24 rotations
# 32:30 input reader ready
# 49:30 rotation method ready
# 1:16:26 starting running good solution
# 1:30:25 autoreloader just eats result :P
# 1:45:30 star1 down
# 1:49:35 star2 down