require 'set'

#INPUT='test'
INPUT='input'

matrix = File.read(INPUT).split("\n").map{|r|r.split("")}
matrix_in = File.read(INPUT).split("\n").map{|r|r.split("")}

def dupeempty matrix
	i = 0
	while i < matrix.length
		if matrix[i].to_set.to_a == ['.']
			matrix.insert(i, matrix[i].dup)
			i += 1
		end
		i += 1
	end
	matrix
end

def empties matrix
	matrix.length.times.filter do |i|
		matrix[i].to_set.to_a == ['.']
	end
end

# matrix.each do |row|
# 	p row
# end

# grow
matrix = dupeempty(dupeempty(matrix).transpose).transpose  
n_row = matrix.length
n_col = matrix.first.length

# points
stars = []
n_row.times do |y|
	n_col.times do |x|
		stars << [y, x] if matrix[y][x] == '#'
	end
end

distances = {}

p (stars.length.times.map do |i1|
	(i1+1...stars.length).map do |i2|
		(stars[i1].first-stars[i2].first).abs + (stars[i1].last-stars[i2].last).abs
	end
end.flatten.sum)

n_row = matrix_in.length
n_col = matrix_in.first.length

e_rows = empties(matrix_in).to_set
e_cols = empties(matrix_in.transpose).to_set

stars = []
n_row.times do |y|
	n_col.times do |x|
		stars << [y, x] if matrix_in[y][x] == '#'
	end
end

def countempty(p1, p2, es)
	p1, p2 = [p1, p2].sort
	es.each.filter do |v|
		v > p1 && v < p2
	end.length
end

p (stars.length.times.map do |i1|
	(i1+1...stars.length).map do |i2|
		(stars[i1].first-stars[i2].first).abs + (stars[i1].last-stars[i2].last).abs + countempty(stars[i1].first, stars[i2].first, e_rows) * 999999 + countempty(stars[i1].last, stars[i2].last, e_cols) * 999999
	end
end.flatten.sum)

# 11   00:15:38   1303      0   00:23:03   1306      0