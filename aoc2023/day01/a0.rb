#INPUT='test'
INPUT='input'

NUMBERS = [
	'zero',
	'one',
	'two',
	'three',
	'four',
	'five',
	'six',
	'seven',
	'eight',
	'nine',
]

def get_num value, do_letters=false
	value.length.times do |pos|
		NUMBERS.each_with_index do |number_str, number_val|
			value[pos...pos+1] = number_val.to_s if value[pos...pos+number_str.length] == number_str
		end
	end if do_letters
	digits = value.split("").filter{|c|c.match?(/\d/)}
	digits.first.to_i * 10 + digits.last.to_i
end

p File.read(INPUT).split("\n").map{|v|get_num(v)}.sum
p File.read(INPUT).split("\n").map{|v|get_num(v, do_letters=true)}.sum

#   1   00:05:57  2722      0   00:19:30  1677      0
# assumed "twone" is "2" only, not "21"
