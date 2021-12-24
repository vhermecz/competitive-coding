require 'set'

INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	row = row.strip.split(" ")
	row.map do |part|
		part.to_i.to_s == part ? part.to_i : part
	end
end

def load(mem, ref)
	raise "missing-op2" if ref.nil?
	res = ref.kind_of?(Integer)? ref : mem[ref]
	# p [ref, res]
	res
end

def eval(mem, instruction, input)
	mnem, op1, op2 = instruction
	raise "invalid-op1" if op1.kind_of? Integer
	if mnem == "inp"
		mem[op1] = input.pop
		#p mem["z"]
	elsif mnem == "add"
		mem[op1] = load(mem, op1) + load(mem, op2)
	elsif mnem == "mul"
		mem[op1] = load(mem, op1) * load(mem, op2)
	elsif mnem == "div"
		# negative rounded down not toward zero!
		val1 = load(mem, op1)
		val2 = load(mem, op2)
		raise "div-error" if val2 == 0
		raise "div-rounding-error" if val2*val1 < 0
		mem[op1] = val1 / val2
	elsif mnem == "mod"
		val1 = load(mem, op1)
		val2 = load(mem, op2)
		raise "mod-error-op1" if val1 < 0
		raise "mod-error-op2" if val2 <= 0
		mem[op1] = val1 % val2
	elsif mnem == "eql"
		mem[op1] = (load(mem, op1) == load(mem, op2)) ? 1 : 0
	else
		raise "invalid-mnemomin"
	end
end

def run(code, input)
	p "RUN"
	input = input.to_s.split("").map(&:to_i).reverse if input.kind_of? Integer
	return nil unless input.tally[0].nil?
	#raise "cannot-zero" unless input.tally[0].nil?
	mem = "wxyz".split("").map{|v|[v, 0]}.to_h
	code.each_with_index do |instruction, idx|
		begin
			eval(mem, instruction, input)
		rescue => error
			p error.message
			p idx
			raise error
		end
	end
	mem["z"] # == 0
end

PARAMS = [
	[ 1, 13, 3],
	[ 1, 11,12],
	[ 1, 15, 9],
	[26, -6,12],
	[ 1, 15, 2],
	[26, -8, 1],
	[26, -4, 1],
	[ 1, 15,13],
	[ 1, 10, 1],
	[ 1, 11, 6],
	[26,-11, 2],
	[26,  0,11],
	[26, -8,10],
	[26, -7, 3],
]

def run2(input)
	p "RUN2"
	input = input.to_s.split("").map(&:to_i).reverse if input.kind_of? Integer
	return nil unless input.tally[0].nil?
	params = PARAMS.map(&:dup).reverse
	z = 0
	p input
	input.reverse.each do |w|
		#p z
		param1, param2, param3 = params.pop
		z0 = z%26
		z /= param1
		if w != (z0 + param2)
			z *= 26
			z += w + param3
		end
	end
	z
end

def run3(input)
	input = input.to_s.split("").map(&:to_i).reverse if input.kind_of? Integer
	params = PARAMS.map(&:dup).reverse
	z = []
	input.reverse.each do |w|
		p z
		param1, param2, param3 = params.pop
		v = z[-1]||0
		z.pop if param1 == 26
		if w != v + param2
			z << w + param3  # ASSUMES value in 0..25
		end
	end
	res = z.map{|v|(v+65).chr}.join("")
	p ["res", res, z]
	res
end


def solve(code)
	testnum = (["9"]*14).join("").to_i
	while !run(code, testnum.to_s.split("").map(&:to_i).reverse)
		p testnum if testnum % 1000 == 0
		testnum -= 1
	end
end

def solve2(code)
	testnum = (["9"]*14).join("").to_i
	while true
		testnum = 14.times.map{rand(1..9).to_s}.join("").to_i
#		testnum = 29547643461281
		testnum = 91699394894995
		testnum = 51147191161261
		#res = run(code,testnum)
		#p [testnum, res, run2(testnum), decode(res), run3(testnum)]
		run3(testnum)
		exit
		exit if res!=run2(testnum)
	end
end

def decode(v)
	out = ""
	while v>0
		out += (v%26+65).chr
		v /= 26
	end
	out.reverse
end

# 14.times do |i|
# 	p data[i*18,18].flatten.join("")
# end

print solve2(data)

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
