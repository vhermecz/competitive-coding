def count_collatz(a)
	(0..).each do |i|
		return i if a==1
		a = if a%2==1
			3*a+1
		else
			a/2
		end
	end
end

puts count_collatz(26623)
puts count_collatz(31911)

# learning from 21day24, solved by hand in 15 minutes
