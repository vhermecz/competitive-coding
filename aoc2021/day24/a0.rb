require 'set'

INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.strip.split(" ")
	row.map do |part|
		part.to_i.to_s == part ? part.to_i : part
	end
end

def extract_params(code)
	raise "Unexpected code length" unless code.length == 14*18
	# TODO: Add assertion on instructions
	14.times.map{|idx|[4,5,15].map{|v|code[18*idx+v].last}}
end

def extract_constraints(params)
	constraints = []
	z = []
	params.each_with_index do |(p1,p2,p3), idx|
		if p1 == 1
			z << [idx, p3]
		else
			idx_last, offset = z.pop
			constraints << [idx, idx_last, p2+offset]
		end
	end
	constraints
end

def valid_pairs(offset)
	if offset >= 0
		((offset+1)..9).map{|i|[i-offset,i]}
	else
		((1-offset)..9).map{|i|[i,i+offset]}
	end
end

def solve(constraints, max:true)
	res = [0]*14
	constraints.each do |(pos2, pos1, offset)|
		pairs = valid_pairs(offset)  # TODO: could be reduced
		val1, val2 = max ? pairs.last : pairs.first
		res[pos1]=val1
		res[pos2]=val2
	end
	res.reduce{|acc,v|10*acc+v}
end

p solve(extract_constraints(extract_params(data)),max:true)
p solve(extract_constraints(extract_params(data)),max:false)

# 02:09:31    622 - 91699394894995
# 02:13:33    565 - 51147191161261

#  6m - start coding
# 33m - interpreter ready
#   - mod in interpreter does op2%op2 => always 0
#       (introduced@28 during refactor) (fixed@85m)
# 38m - hunch that this is repetitive
# 43m - hunch confirmed
# 59m - first handcraft (lil bogus)
#   - handcraft takes input in reverse order (fixed@94m)
# 60m - params extracted
# 65m - interpreter vs handcraft debugging (not matching)
# 76..78m - handcraft with stack
#   - always-pops fixed@111m 
# 95m - handcraft2 with stack
# 113m - manual solve
# 120m - manual solve ready, got constraints 
#   - `d12==d9+1` bug (missed the 1) (fixed@129m, lost 5m)
# 129m - star1down
# 133m - star2down
# 228m - cleanup done
