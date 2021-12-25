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
	# horiz
	omaze = maze
	maze = maze.map(&:dup)
	h.times.each do |r|
		w.times.each do |c|
			if omaze[r][(c+1)%w]=='.' && omaze[r][c] ==">"
				maze[r][(c+1)%w] = ">"
				maze[r][c] = "."
				moved = true
			end
		end
	end
	#vertical
	omaze = maze
	maze = maze.map(&:dup)
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

# timelog
# 00:30 - start reading
# 03:21 - start coding (initial code '\n' vs "\n" bug)
# 06:05 - parser done (instead of in 20seconds :P lol)
# 15:25 - first sol
#  - forgot checking if there is a cucumber to move (fixed@20:18)
#  - interpreted moving-at-once instead of checking-at-once (fixed@24:45)
# 25:02 - done
