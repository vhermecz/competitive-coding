require 'set'

INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n\n").map do |section|
	section.split("\n").map do |row|
		row.split("")
	end
end

def is_reflect_row(matrix, i, exc=nil)
	top = matrix[..i].reverse
	bot = matrix[i+1..]
	len = [top.length, bot.length].min
	len > 0 and top[...len] == bot[...len] and exc!=i
end

def reflect_idx matrix, exc=nil
	matrix.length.times do |i|
		return i+1 if is_reflect_row matrix, i, exc
	end
	return nil
end

def get_reflect_score matrix, exc=nil
	exc_row = exc.nil? ? nil : exc/100-1
	score = reflect_idx(matrix, exc_row)
	if !score.nil?
		score * 100
	else
		exc_col = exc.nil? ? nil : exc%100-1
		reflect_idx(matrix.transpose, exc_col)
	end
end	

def part1 matrices
	matrices.map do |matrix|
		get_reflect_score(matrix)
	end.sum
end

def part2 matrices
	matrices.map do |matrix|
		alter_score(matrix)
	end.sum
end

def alter_score matrix
	origi = get_reflect_score(matrix)
	matrix.length.times do |y|
		matrix[0].length.times do |x|
			old = matrix[y][x]
			matrix[y][x] = (old == '.' ? '#' : '.')
			neu = get_reflect_score(matrix, exc=origi)
			if !neu.nil?
				return neu
			end
			matrix[y][x] = old
		end
	end
end

# solve
p part1(data)
p part2(data)

# 13   00:16:27    657      0   00:29:41    957      0
# 28895
# 31603
