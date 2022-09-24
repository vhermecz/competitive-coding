import api
import sys

PROBLEM_ID = "line-of-sight"

TEST = {
  "boardSize": 8,
  "obstacles": [
    { "x": 4, "y": 1 },
    { "x": 3, "y": 4 },
    { "x": 4, "y": 7 },
    { "x": 4, "y": 5 },
    { "x": 0, "y": 3 },
    { "x": 2, "y": 0 },
    { "x": 7, "y": 6 },
    { "x": 5, "y": 2 }
  ]
}

def solve_for_path(start_pos, dir_, obstacles, sight):
	# build variables
	n = len(obstacles)
	scanline = []
	pos = start_pos
	while 0 <= pos[0] < n and 0 <= pos[1] < n:
		scanline.append(obstacles[pos[1]][pos[0]])
		pos = (pos[0]+dir_[0], pos[1]+dir_[1])
	scanline = [1] + scanline + [1]
	scansight = [0] * len(scanline)
	# solve sight
	last_block = 0
	for i in range(1, len(scanline)):
		if scanline[i] == 1:
			for j in range(last_block+1, i):
				scansight[j] = i - last_block - 1
			last_block = i
	scansight = scansight[1:-1]
	# update sight
	pos = start_pos
	idx = 0
	while 0 <= pos[0] < n and 0 <= pos[1] < n:
		sight[pos[1]][pos[0]] += scansight[idx]
		pos = (pos[0]+dir_[0], pos[1]+dir_[1])
		idx += 1

def solve(input):
	# build variables
	n = input["boardSize"]
	obstacles = [[0]*n for _ in range(n)]
	sight = [[0]*n for _ in range(n)]
	for pos in input["obstacles"]:
		obstacles[pos["y"]][pos["x"]] = 1
	# scan
	for i in range(n):
		solve_for_path((i, 0), (0, 1), obstacles, sight)  # vertical
		solve_for_path((0, i), (1, 0), obstacles, sight)  # horizontal
		solve_for_path((i, 0), (1, 1), obstacles, sight)  # top diag
		if i > 0:
			solve_for_path((0, i), (1, 1), obstacles, sight)  # left diag
		solve_for_path((i, 0), (-1, 1), obstacles, sight)  # top backdiag
		if i > 0:
			solve_for_path((n-1, i), (-1, 1), obstacles, sight)  # right backdiag
	best_pos = None
	best_score = -1
	for x in range(n):
		for y in range(n):
			if sight[y][x] > best_score:
				best_score = sight[y][x]
				best_pos = (x,y)
	return {
		"x": best_pos[0],
		"y": best_pos[1],
	}

submission = api.start_sub(PROBLEM_ID)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	print(test)
	output = solve(test["input"])
	result = api.post_test(test["test_id"], output)
	print(result)

r=api.post_source(PROBLEM_ID, __file__)
print(r)
