import api
import sys

PROBLEM_ID = "sanity-check"


def onecount(num):
	return f"{num:b}".count("1")

def getinsane_inner(values):
	counts = list(map(onecount, values))
	highcount = max(counts)
	return list(map(lambda vs:vs[1], filter(lambda vs: vs[0]==highcount, zip(counts, values))))

def getinsane(input):
	res = getinsane_inner(input["set"])
	return {
		"insane_numbers": res,
    }


submission = api.start_sub(PROBLEM_ID, 1)
for tcount in range(submission['test_count']):
	print(tcount)
	test = api.get_sub_test(submission['id'])
	print(test)
	output = getinsane(test["input"])
	result = api.post_test(test["test_id"], output)
	print(result)

r=api.post_source(PROBLEM_ID, __file__)
print(r)
