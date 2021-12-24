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
	ref.kind_of?(Integer)? ref : mem[ref]
end

def eval(mem, instruction, input)
	mnem, op1, op2 = instruction
	raise "invalid-op1" if op1.kind_of? Integer
	mem[op1] = begin
		if mnem == "inp"
			input.pop
		else
			raise "missing-op2" if op2.nil?
			val1 = load(mem, op1)
			val2 = load(mem, op2)
			if mnem == "add"
				load(mem, op1) + load(mem, op2)
			elsif mnem == "mul"
				load(mem, op1) * load(mem, op2)
			elsif mnem == "div"
				raise "div-error" if val2 == 0
				raise "div-rounding-error" if val2*val1 < 0  # impl failsafe. round down while should round twds zero
				val1 / val2
			elsif mnem == "mod"
				raise "mod-error-op1" if val1 < 0
				raise "mod-error-op2" if val2 <= 0
				val1 % val2
			elsif mnem == "eql"
				val1==val2 ? 1 : 0
			else
				raise "invalid-mnemomic"
			end
		end
	end
end

Error = Struct.new(:message)

def run(code, input_number)
	input = input_number.to_s.split("").map(&:to_i).reverse
	return Error.new "input_number has 0 digit" unless input.tally[0].nil?
	mem = "wxyz".split("").map{|v|[v, 0]}.to_h
	code.each_with_index do |instruction, idx|
		begin
			eval(mem, instruction, input)
		rescue => error
			return Error.new "CPU failed at instruction #{idx+1} with #{error.message}"
		end
	end
	return Error.new "Input rejected. z=#{mem["z"]}" if mem["z"] != 0
	true
end

def extract_params(code)
	raise "Unexpected code length" unless code.length == 14*18
	14.times.map{|idx|[4,5,15].map{|v|code[18*idx+v].last}}
end

def run_handcraft(code, input_number)
	input = input_number.to_s.split("").map(&:to_i)
	return Error.new "input_number has 0 digit" unless input.tally[0].nil?
	params = extract_params(code).reverse
	z = []
	input.each do |w|
		param1, param2, param3 = params.pop
		v = z[-1]||0
		z.pop if param1 == 26
		if w != v + param2
			z << w + param3  # ASSUMES value in 0..25
		end
	end
	zvalue = z.reduce(0){|acc,v|26*acc+v}
	return Error.new "Input rejected. z=#{zvalue} aka #{z}" unless z.empty?
	true
end

def solve(code)
	while true
		testnum = 14.times.map{rand(1..9).to_s}.join("").to_i
		res1 = run(code,testnum)
		res2 = run_handcraft(code,testnum)
		p [testnum, res1, res2]
	end
end

solve(data)

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
