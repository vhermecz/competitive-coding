$rules = File.open("input").read.split("\n").map do |row|
	op, target = row.strip.split(" -> ")
	[target, op.split(" ")]
end.to_h
$mem = Hash.new
def eval(var)
	$mem[var] ||= begin
		op = $rules[var]
		if op.nil?
			var.to_i
		elsif op.length == 1
			eval(op[0])
		elsif op.length == 2
			~eval(op[1]) & 65535
		elsif op[1] == 'AND'
			eval(op[0]) & eval(op[2])
		elsif op[1] == 'OR'
			eval(op[0]) | eval(op[2])
		elsif op[1] == 'LSHIFT'
			(eval(op[0]) * (2**op[2].to_i)) & 65535
		else
			eval(op[0]) / (2**op[2].to_i)
		end
	end
end

p eval('a')
$rules['b'] = [eval('a').to_s]
$mem = Hash.new
p eval('a')
