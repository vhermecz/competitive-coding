import api
import sys
import collections

PROBLEM_ID = "the-escape"

class Maze:
	def __init__(self, input):
		self.maze = input
		self.width = len(input[0])
		self.height = len(input)
		artifacts = {}
		for y in range(0, self.height):
			for x in range(0, self.width):
				if input[y][x] not in ["#", "."]:
					artifacts[input[y][x]] = (x, y)
		self.artifacts = artifacts

	def is_tile(self, x, y):
		if x<0 or x>=self.width:
			return False
		if y<0 or y>=self.height:
			return False
		return self.maze[y][x] != "#"

	def shortest_path(self, start, end):
		seen = set()
		backref = dict()
		backlog = collections.deque([start])
		while len(backlog):
			pos = backlog.popleft()
			if pos == end:
				break
			for npos, ndir in expand(*pos):
				if self.is_tile(*npos) and not npos in backref:
					backref[npos] = (pos, ndir)
					backlog.append(npos)
		if pos == end:
			path = []
			while pos != start:
				pos, ndir = backref[pos]
				path.append(pos)
			return path[::-1]
		else:
			return None


def expand(x,y):
	return [
		((x+1, y), "R"),
		((x-1, y), "L"),
		((x, y+1), "D"),
		((x, y-1), "U"),
	]

def solve(input):
	maze = Maze(input)
	to_key = maze.shortest_path(maze.artifacts["S"], maze.artifacts["K"])
	to_exit = maze.shortest_path(maze.artifacts["K"], maze.artifacts["E"])
	full = to_key + to_exit + [maze.artifacts["E"]]
	result = [{ "x": x, "y": y} for (x,y) in full]
	return result

TEST = [
  ["#", "E", "#", "#", "#"],
  ["#", ".", "#", "K", "#"],
  ["#", ".", "#", ".", "#"],
  ["#", ".", ".", ".", "#"],
  ["#", "S", "#", "#", "#"]
]

#print(solve(TEST))
#sys.exit()

submission = api.start_sub(PROBLEM_ID)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	#print(test)
	output = solve(test["input"])
	result = api.post_test(test["test_id"], output)
	print(result)

r=api.post_source(PROBLEM_ID, __file__ + ".zip")
print(r)

