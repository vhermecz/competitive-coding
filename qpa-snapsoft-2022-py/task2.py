import api
import sys

PROBLEM_ID = "mad-doctor"


def solve(input):
	portions = [0] * len(input)
	lo2hi = map(lambda x:x[0], sorted(list(enumerate(input)), key=lambda x:x[1]))
	for idx in lo2hi:
		portion = 1
		if idx > 0 and input[idx-1] < input[idx]:
			portion = max(portion, portions[idx-1]+1)
		if idx < len(input)-1 and input[idx+1] < input[idx]:
			portion = max(portion, portions[idx+1]+1)
		portions[idx] = portion
	print(portions)
	return sum(portions)

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
