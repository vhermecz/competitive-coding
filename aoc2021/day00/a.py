import collections, itertools

INFILE = 'test'
#INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			yield row.strip()

def solve(data):
	return len(data)


data = list(read_input(INFILE))
res = solve(data)

print(res)
