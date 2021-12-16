require 'set'

#INPUT='test'
INPUT='input'

# read_input
$data = []
File.open( INPUT ) do |f|
	row = f.gets.strip
	$data = [row].pack('H*').unpack('B*').first.split('').reverse
end

class Array
	def popn(n)
		n.times.map{self.pop}
	end
	def getbits(n)
		self.popn(n).join.to_i(2)
	end
end

def process_literal(data)
	acc = ""
	while true
		group = $data.popn(5)
		acc += group[1..].join
		break if group[0]=='0'
	end
	acc.to_i(2)
end

def process_operator(data, type_id)
	# operator packate
	length_type_id = data.getbits(1)
	values = if length_type_id == 0
		num_bits = data.getbits(15)
		target_length = data.length - num_bits
		subs = []
		while data.length != target_length
			subs << process(data)
		end
		subs
	else
		num_subpackets = data.getbits(11)
		num_subpackets.times.map do
			process(data)
		end
	end
	case type_id
		when 0 then values.sum
		when 1 then values.inject(1) {|m,x| m * x}
		when 2 then values.min
		when 3 then	values.max
		when 5 then	values.first > values[1] ? 1 : 0
		when 6 then values.first < values[1] ? 1 : 0
		when 7 then	values.first == values[1] ? 1 : 0
	end
end

$cnt = 0
def process(data)
	version = data.getbits(3)
	type_id = data.getbits(3)
	$cnt += version
	if type_id == 4
		process_literal(data)
	else
		process_operator(data, type_id)
	end
end

p $cnt
p process($data)

# 00:31:44    421 - 847
# 00:37:48    357 - 333794664059
