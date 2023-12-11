require 'set'

#INPUT='test'
INPUT='input'

matrix = File.read(INPUT).split("\n").map{|r|r.split("")}

def solve_dim matrix, expansion
	rowcounts = matrix.map{|r|r.filter{|v|v=='#'}.length}
	total = rowcounts.sum
	seen = 0
	rowcounts.map do |rowcount|
		res = seen * (total - seen)
		seen += rowcount
		res * (rowcount.zero? ? expansion : 1)
	end.sum
end

def solve matrix, expansion
	solve_dim(matrix, expansion) + solve_dim(matrix.transpose, expansion)
end

p solve(matrix, 2)
p solve(matrix, 1000000)
