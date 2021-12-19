require 'digest'

puts 1e10.to_i.times do |v|
	hd = Digest::MD5.hexdigest ("ckczppom" + v.to_s)
	break v if hd[0,5] == '000000'
end
puts 1e10.to_i.times do |v|
	hd = Digest::MD5.hexdigest ("ckczppom" + v.to_s)
	break v if hd[0,6] == '00000'
end
