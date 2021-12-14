import collections, itertools
INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		return [[int(item) for item in row.strip()] for row in fp]

data = list(read_input(INFILE))
h = len(data)
w = len(data[0])

def get_value(data, r, c):
	h = len(data)
	w = len(data[0])
	if 0 <= r < h and 0 <= c < w:
		return data[r][c]
	else:
		return 10

def get_nb_values(data, r, c):
	return sorted((get_value(data, r+dr, c+dc),(r+1*dr,c+1*dc)) for dr, dc in NBS)

NBS = [(-1, 0), (1, 0), (0, 1), (0, -1)]

res = 0
for r in range(h):
	for c in range(w):
		if get_value(data, r, c) < min(get_value(data, r+dr, c+dc) for dr, dc in NBS):
			res += 1 + get_value(data, r, c)

print(res)


downs = dict()
starts = set()

res = 0
for r in range(h):
	for c in range(w):
		nbs = get_nb_values(data, r, c)
		if get_value(data, r, c) < nbs[0][0]:
			downs[(r,c)]=(r,c)
			starts.add((r,c))
		elif nbs[0][0] < get_value(data, r, c) and nbs[0][0] < nbs[1][0]:
			downs[(r,c)]=nbs[0][1]

graph = collections.defaultdict(list)
for fr, to in downs.items():
	graph[to].append(fr)

sizes = []
conn = []
for _ in range(h):
	conn.append([0]*w)
for idx, start in enumerate(starts):
	visited = set()
	expand = [start]
	while len(expand):
		curr = expand.pop()
		if curr in visited:
			continue
		visited.add(curr)
		conn[curr[0]][curr[1]] = idx+1
		nbs = get_nb_values(data, curr[0], curr[1])
		for nb in nbs:
			if nb[0] < 9:
				expand.append(nb[1])
	sizes.append(len(visited))

#for r in conn:
#	print(''.join(map(str,r)))

sizes = sorted(sizes)
print(sizes[-1]*sizes[-2]*sizes[-3])

# 00:06:51    697 - 448
# 00:34:50   2407 - 1417248
#  Tried tracking back through gradient, but ther e
#    downs and graph is used for that
#    but that is ambigious
#  Then spotted that all basins are surrounded by 9s
