import collections, itertools
INFILE = 'test'
INFILE = 'input'

COUNTS = {0: 6, 1:2, 2:5, 3:5, 4:4, 5:5, 6:6, 7:3, 8:7, 9:6}

CODES = {
    0: "abcefg",
    1: "cf",
    2: "acdeg",
    3: "acdfg",
    4: "bcdf",
    5: "abdfg",
    6: "abdefg",
    7: "acf",
    8: "abcdefg",
    9: "abcdfg",
}
DECODES = dict([(b, a) for a,b in CODES.items()])

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			a,b = row.strip().split(' | ')
			a=a.split(" ")
			b=b.split(" ")
			a=[sorted(x) for x in a]
			b=[sorted(x) for x in b]
			yield a,b

def solver(sample, code):
	for candidate in itertools.permutations("abcdefg"):
		solver = dict(zip(candidate, CODES[8]))
		for item in sample:
			item2 = ''.join(sorted(map(lambda x:solver[x], item)))
			if item2 not in DECODES.keys():
				break
		else:
			num = 0
			for item in code:
				item = ''.join(sorted(map(lambda x:solver[x], item)))
				num = 10*num + DECODES[item]
			return num

data = list(read_input(INFILE))

cnt=0
for t, r in data:
	for i in r:
		if len(i) in [2,3,4,7]:
			cnt+=1
print(cnt)

cnt=0
for t, r in data:
	cnt += solver(t, r)

print(cnt)

#   00:09:01   1515 - 344
#   00:23:56    167 - 1048410

#   00:20:51 for getting 100. place

