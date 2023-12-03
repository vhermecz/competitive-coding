require 'set'

INPUT='test'
INPUT='input'

class String
  def is_digit?
	  code = self.ord
	  48 <= code && code <= 57
  end
end

data = File.read(INPUT).split("\n").map{|line|line.split("")}

n_row = data.length
n_col = data.first.length

cell_to_range = {}

n_row.times do |i_row|
	n_col.times do |i_col|
		if data[i_row][i_col].is_digit?
			s_col = i_col
			s_col -= 1 while s_col >= 0 && data[i_row][s_col].is_digit?
			e_col = i_col
			e_col += 1 while e_col < n_col && data[i_row][e_col].is_digit?
			cell_to_range[[i_row, i_col]] = [i_row, s_col+1, e_col-1]
		end
	end
end

p cell_to_range

candidates = Set[]

n_row.times do |i_row|
	n_col.times do |i_col|
		if !data[i_row][i_col].is_digit? && data[i_row][i_col] != '.'
			[-1, 0, 1].each do |d_row|
				[-1, 0, 1].each do |d_col|
					t_row = i_row + d_row
					t_col = i_col + d_col
					next if t_row < 0 || t_row >= n_row
					next if t_col < 0 || t_col >= n_col
					next if !data[t_row][t_col].is_digit?
					candidates.add(cell_to_range[[t_row, t_col]])
				end
			end
		end
	end
end

res = candidates.map do |i_row, s_col, e_col|
	(s_col..e_col).each.map do |i_col|
		data[i_row][i_col]
	end.join("").to_i
end

p res.sum

part2 = 0
n_row.times do |i_row|
	n_col.times do |i_col|
		if data[i_row][i_col] == '*'
			gear_candidate = Set[]
			[-1, 0, 1].each do |d_row|
				[-1, 0, 1].each do |d_col|
					t_row = i_row + d_row
					t_col = i_col + d_col
					next if t_row < 0 || t_row >= n_row
					next if t_col < 0 || t_col >= n_col
					next if !data[t_row][t_col].is_digit?
					gear_candidate.add(cell_to_range[[t_row, t_col]])
				end
			end
			if gear_candidate.length == 2
				a, b = gear_candidate.map do |i_row, s_col, e_col|
					(s_col..e_col).each.map do |i_col|
						data[i_row][i_col]
					end.join("").to_i
				end
				part2 += a*b
			end
		end
	end
end

p part2
