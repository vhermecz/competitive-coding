require 'set'

#INPUT='test'
INPUT='input'

matrix = File.read(INPUT).split("\n").map{|r|r.split("")}

def solve_dim matrix, expansion
	starcnt = matrix.flatten.filter{|v|v=='#'}.length
	seen = 0
	matrix.map do |row|
		rowcnt = row.filter{|v|v=='#'}.length
		res = seen*(starcnt-seen)
		res *= expansion if rowcnt == 0
		seen += rowcnt
		res
	end.sum
end

def solve matrix, expansion
	solve_dim(matrix, expansion) + solve_dim(matrix.transpose, expansion)
end

p solve(matrix, 2)
p solve(matrix, 1000000)
