require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map{|r|r.strip.split("")}
h = data.length
w = data.first.length

def move maze
	h = maze.length
	w = maze.first.length
	moved = false
	omaze = maze
	maze = maze.map(&:dup)
	# horiz
	h.times.each do |r|
		w.times.each do |c|
			if omaze[r][(c+1)%w]=='.' && omaze[r][c] ==">"
				maze[r][(c+1)%w] = ">"
				maze[r][c] = "."
				moved = true
			end
		end
	end
	omaze = maze
	maze = maze.map(&:dup)
	#vertical
	w.times.each do |c|
		h.times.each do |r|
			if omaze[(r+1)%h][c]=='.' && omaze[r][c] == "v"
				maze[(r+1)%h][c] = "v"
				maze[r][c] = "."
				moved = true
			end
		end
	end
	[maze, moved]
end

def dbg(maze)
	maze.each do |rmaze|
		p rmaze.join("")
	end
end

def solve(maze)
	cnt = 0
	while true
		maze, moved = move(maze)
		cnt += 1
		return cnt if !moved
	end
end

p solve(data)

# 00:25:02   1149 - 560
