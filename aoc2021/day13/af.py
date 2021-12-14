import collections, itertools

INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	coords = []
	folds = []
	with open(fname) as fp:
		while True:
			row = fp.readline().strip()
			if row == "":
				break
			row = row.split(",")
			coords.append(tuple(map(int, row)))
		while True:
			row = fp.readline().strip()
			if row == "":
				break
			axis, value = row[11:].split("=")
			folds.append((axis, int(value)))
		return dict(
			coords=coords,
			folds=folds,
		)


def solve(data):
	coords = data['coords']
	folds = data['folds']
	for axis, value in folds:
		print(len(coords))
		newcoords = list()
		for x, y in coords:
			#print(x,y)
			if axis == 'y':
				y = value - abs(y - value)
			else:
				x = value - abs(x - value)
			newcoords.append((x,y))
			
		coords = list(set(newcoords))
	print(len(coords))
	return coords

data = read_input(INFILE)
res = solve(data)

xs, ys = zip(*res)
w = max(xs)+1
h = max(ys)+1
arr = [' '] * w * h
for x, y in res:
	arr[y*w+x] = 'X'

for i in range(h):
	print(''.join(arr[i*w:(i+1)*w]))
