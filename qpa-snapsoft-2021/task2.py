import api
import sys
import collections

PROBLEM_ID = "maze"

class Maze:
	def __init__(self, input):
		self.maze = input["maze"]
		self.width = input["width"]
		self.height = input["height"]
		self.start = (input["startCell"]["x"], input["startCell"]["y"])
		self.end = (input["endCell"]["x"], input["endCell"]["y"])

	def is_tile(self, x, y):
		if x<0 or x>=self.width:
			return False
		if y<0 or y>=self.height:
			return False
		return self.maze[self.width * y + x] == 1

def expand(x,y):
	return [
		((x+1, y), "R"),
		((x-1, y), "L"),
		((x, y+1), "D"),
		((x, y-1), "U"),
	]

def solve(input):
	maze = Maze(input)
	seen = set()
	backref = dict()
	backlog = collections.deque([maze.start])
	while len(backlog):
		pos = backlog.popleft()
		if pos == maze.end:
			break
		for npos, ndir in expand(*pos):
			if maze.is_tile(*npos) and not npos in backref:
				backref[npos] = (pos, ndir)
				backlog.append(npos)
	if pos == maze.end:
		path = []
		while pos != maze.start:
			pos, ndir = backref[pos]
			path.append(ndir)
		return "".join(path[::-1])
	else:
		return None

submission = api.start_sub(PROBLEM_ID)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	#print(test)
	output = solve(test["input"])
	result = api.post_test(test["test_id"], {"solution":output})
	print(result)

r=api.post_source(PROBLEM_ID, __file__ + ".zip")
print(r)

