import api
import sys

PROBLEM_ID = "mad-doctor"


def solve(input):
	res = getinsane_inner(input["set"])
	return {
		"insane_numbers": res,
    }


submission = api.start_sub(PROBLEM_ID, 1)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	print(test)
	output = solve(test["input"])
	result = api.post_test(test["test_id"], output)
	print(result)

r=api.post_source(PROBLEM_ID, __file__)
print(r)
