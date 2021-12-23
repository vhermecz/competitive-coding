#dec20 19:46:40
#dec20 19:47:30
#dec21 18:51:00

data = File.read("input").split("\n").map{|row|row.strip.split("")}

def iter(matrix)
	w = matrix.first.length
	h = matrix.length
	h.times.map do |y|
		w.times.map do |x|
			stat = (-1..1).map do |dy|
				(-1..1).map do |dx|
					matrix[y+dy][x+dx] if x+dx>=0 && x+dx<w && y+dy>=0 && y+dy<h && !(dx==0 && dy==0)
				end
			end.flatten.tally
			(stat["#"]==3 || stat["#"]==2 && matrix[y][x] == '#')?"#":"."
		end
	end
end

def stuck matrix
	matrix[0][0] = "#"
	matrix[0][-1] = "#"
	matrix[-1][0] = "#"
	matrix[-1][-1] = "#"
end

matrix = data
100.times{matrix = iter matrix}
p matrix.flatten.tally["#"]

matrix = data
100.times{stuck matrix;matrix = iter matrix}
stuck matrix
p matrix.flatten.tally["#"]
# 18:57:29 st1 - 814
# 19:00:26 st2 - 924
# 19:05:44 cleanup
