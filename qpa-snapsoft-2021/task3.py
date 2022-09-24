import api
import sys
import collections

PROBLEM_ID = "king-pinned"

PAWN = 1
ROOK = 2
KNIGHT = 3
BISHOP = 4
QUEEN = 5
MAFIA_BOSS = 6
KING = 7
EMPTY = 0

STEPS_KNIGHT = [(-2, -1), (-2, 1), (2, -1), (2, 1), (-1,-2), (-1,2), (1,-2), (1,2)]
STEPS_ROOK = [(1, 0), (0, -1), (0, 1), (-1 ,0)]
STEPS_BISHOP = [(1, -1), (1, 1), (-1, -1), (-1, 1)]
STEPS_KING = STEPS_ROOK + STEPS_BISHOP
STEPS_PAWN = [(0, 1)]

STEPS = {
	ROOK: STEPS_ROOK,
	BISHOP: STEPS_BISHOP,
	QUEEN: STEPS_ROOK + STEPS_BISHOP,
	KNIGHT: STEPS_KNIGHT,
	KING: STEPS_KING,
	PAWN: STEPS_PAWN,
}

MANYSTEPS = [ROOK, BISHOP, QUEEN]

def is_outside(pos, size):
	return pos[0]<0 or pos[0]>=size or pos[1]<0 or pos[1]>=size

def step(pos, dir):
	return (pos[0]+dir[0], pos[1]+dir[1])

def solve(maze):
	size = len(maze)
	boss_pos = None
	scores = {}
	pieces = []
	for col in range(size):
		for row in range(size):
			pos = (col, row)
			cell = maze[row][col]
			if cell == MAFIA_BOSS:
				boss_pos = pos
			elif cell == EMPTY:
				scores[pos] = 0 
			else:
				pieces.append((pos, cell))
	for pos, kind in pieces:
		for step_dir in STEPS[kind]:
			curr_pos = pos
			while True:
				curr_pos = step(curr_pos, step_dir)
				if is_outside(curr_pos, size) or curr_pos not in scores:
					# outside or a piece is on there
					break
				if kind == KING and max(abs(boss_pos[0]-curr_pos[0]), abs(boss_pos[1]-curr_pos[1])) == 1:
					# if neighbour is white king
					break
				scores[curr_pos] += 1
				if kind not in MANYSTEPS:
					break
	result = sorted([(score, col, row) for (col, row), score in scores.items()])
	return [[col, row] for score, col, row in result]


submission = api.start_sub(PROBLEM_ID)
print(submission)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	print(test)
	output = solve(test["input"]["room"])
	print(output)
	result = api.post_test(test["test_id"], {"places_to_move_to":output})
	print(result)

#r=api.post_source(PROBLEM_ID, __file__ + ".zip")
#print(r)

