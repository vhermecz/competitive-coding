import api
import sys
from itertools import permutations 

PROBLEM_ID = "saw-squarey"


def gen_valids():
	valids = []
	checks = [(0,3,6), (1,4,7), (2,5,8), (0,1,2), (3,4,5), (6,7,8), (0,4,8), (2,4,6)]
	for square in permutations(range(1,10)):
		for i, j, k in checks:
			if square[i] + square[j] + square[k] != 15:
				break
		else:
			valids.append(square)
	return valids

VALID_MAGIC = gen_valids()

def solve(input):
	square = sum(input["square"], [])
	best_cost = None
	for sol in VALID_MAGIC:
		cost = sum(abs(vin-vval) for vin, vval in zip(square, sol))
		if best_cost is None or cost < best_cost:
			best_cost = cost
	return best_cost


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
