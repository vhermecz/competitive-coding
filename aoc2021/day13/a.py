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
		newcoords = list()
		for x, y in coords:
			#print(x,y)
			if axis == 'y':
				y = value - abs(y - value)
			else:
				x = value - abs(x - value)
			newcoords.append((x,y))
			
		coords = list(set(newcoords))
	return coords


data = read_input(INFILE)
res = solve(data)

xs, ys = zip(*res)
print(max(xs), max(ys))
arr = [' '] * (max(xs)+1)*(max(ys)+1)
for x, y in res:
	arr[y*max(xs)+x] = 'X'

for i in range(0, max(xs)*(max(ys)+1), max(xs)):
	print(''.join(arr[i:(i+max(xs))]))

print(res)
print(len(res))
# EFLFJGRF

# 00:23:01   2261 - 631
# 00:32:25   2335 - EFLFJGRF
# timeline
# 1:00 6am
# 1:15 start reading
# 3:40 coding: input parser
# 8:03 input parser ready
# 8:03-8:20 converting from (coords,folds) into {coords,folds} WHY?
# 8:20-9:43 realizing that a ****ing list() is called to read_input output
# 11:14 star1potential, just ****ed up the transformation
# 23:21 Fix: finally the good tranformation
# ... cleaning pring statements
# 24:02 star1
# 24:18 start coding 
# 26:05 start2potential, BUT
#  - using [y][x] on a 1dim array
#  - w/h SHOULD be max(v)+1 not max(v)
#    - first solving it by *2 for allocation. bravo
#    - also clips down bottom line (E vs F lol)
#  - y*w*w indexing
#    - p in range(0,w*h,w) and arr[p*w:]
# 33:26 star2

# star1pot 10:01
# star2pot 12:04
