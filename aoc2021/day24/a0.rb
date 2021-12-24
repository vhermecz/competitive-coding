INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.strip.split(" ")
	row.map do |part|
		part.to_i.to_s == part ? part.to_i : part
	end
end

def extract_code_fingerprint(code)
	14.times.map do |i|
		d=code[i*18,18].flatten
		d[13]=d[16]=d[-7]="P"
		d.join("")
	end.uniq.join ","
end

CODE_FINGERPRINT = "inpwmulx0addxzmodx26divzPaddxPeqlxweqlx0muly0addy25mulyxaddy1mulzymuly0addywaddyPmulyxaddzy"

def extract_params(code)
	raise "Unexpected code length" unless code.length == 14*18
	raise "Unexpected code" unless extract_code_fingerprint(code) == CODE_FINGERPRINT
	14.times.map{|idx|[4,5,15].map{|v|code[18*idx+v].last}}
end

def extract_constraints(code)
	constraints = []
	z = []
	extract_params(code).each_with_index do |(p1,p2,p3), idx|
		if p1 == 1
			z << [idx, p3]
		else
			idx_last, offset = z.pop
			constraints << [idx, idx_last, p2+offset]
		end
	end
	constraints
end

def solve(code, max:true)
	res = [0]*14
	extract_constraints(code).each do |(pos2, pos1, offset)|
		val1 = max ? 9-[0,offset].max : 1-[0,offset].min
		res[pos1]=val1
		res[pos2]=val1 + offset
	end
	res.reduce{|acc,v|10*acc+v}
end

p solve(data, max:true)
p solve(data, max:false)

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
# 249m - cleanup done rlly
