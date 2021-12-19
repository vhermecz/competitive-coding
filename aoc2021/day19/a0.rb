require 'set'

#INPUT='test'
INPUT='input'

def read_input
	File.read(INPUT).split("\n\n").map do |scanner|
		scanner.split("\n")[1..].map do |row|
			row.split(",").map(&:to_i)
		end
	end
end

def sgn(x)
	x<=>0
end

def rot90(orient, rotax)
	[-orient[(rotax+2)%3], orient[(rotax+1)%3], orient[rotax]]
end

def genax
	base = Set[[1,2,3]]
	4.times do |ax|
		base = base.map do |axes|
			3.times.inject([axes]){|acc|acc << rot90(acc.last, ax%3)}
		end.flatten(1).to_set
	end
	base
end

def transform_points(points, tf)
	points.map{|p|tf.map{|i|p[i.abs-1]*sgn(i)}}
end

def translate_points(points, tl)
	points.map{|p|p.zip(tl).map{|i,j|i+j}}
end

def find_patch(coll, datasets, rotations)
	datasets.length.times do |dataset_idx|
		rotations.each do |tf|
			dataset = transform_points(datasets[dataset_idx], tf)
			tls = coll.to_a.product(dataset).map{|p1,p2|[p1[0]-p2[0], p1[1]-p2[1], p1[2]-p2[2]]}
			tls.tally.each do |tl, v|
				return [dataset_idx, tf, tl] if v>=12
			end
		end
	end
	nil
end

rotations = genax
datasets = read_input
coll = datasets.delete_at(0).to_set
spos = [[0,0,0]]
while !datasets.empty?
	p [datasets.length, coll.length]
	idx, tf, tl = find_patch(coll, datasets, rotations)
	spos << tl
	dataset = transform_points(datasets[idx], tf)
	dataset = translate_points(dataset, tl)
	coll |= dataset
	datasets.delete_at(idx)
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

# Initial naive solution is 13m59s
# Reverse order runtime is 7m46s
# Tranclatecount runtime is 50s
#   Avoid the translate+find12
#   If we find the same translation between 12+ points, we are already good
