import collections, itertools

INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			yield [int(x) for x in row.strip()]

def increase(data):
	for y in range(len(data)):
		for x in range(len(data[0])):
			data[y][x] += 1

def getpos(data, x, y):
	if 0 <= y < len(data) and 0 <= x < len(data[0]):
		return (x,y)
	else:
		return None

def readpos(data, x, y):
	pos = getpos(data, x, y)
	if pos is not None:
		x,y = pos
		return data[y][x]
	else:
		return 0

def insync(data):
	for row in data:
		for v in row:
			if v != 0:
				return False
	return True

def printit(data):
	for r in data:
		print(''.join([str(v) if v<=9 else "X" for v in r]))
	print

def boost(data):
	changed = True
	flashed = set()
	while changed:
		changed = False
		for y in range(len(data)):
			for x in range(len(data[0])):
				if readpos(data,x,y)>9 and not (x,y) in flashed:
					flashed.add((x,y))
					for dy in range(-1, 2):
						for dx in range(-1, 2):
							if not(dy==0 and dx==0):
								pos = getpos(data, x+dx, y+dy)
								if pos is not None:
									x0,y0 = pos
									data[y0][x0] += 1
									changed = True
		if not changed:
			break
	for pos in flashed:
		x,y = pos
		data[y][x] = 0
	return len(flashed)

def solve1(data):
	cnt = 0
	printit(data)
	for i in range(100):
		increase(data)
		cnt += boost(data)
		#printit(data)
	return cnt

def solve(data):
	cnt = 0
	while True:
		cnt += 1
		increase(data)
		boost(data)
		if insync(data):
			return cnt
	return cnt

data = list(read_input(INFILE))
res = solve(data)

print(res)

# 00:31:49   2779 - 1585
# 00:35:05   2617 -  382
#Timeline
#  0:01 6:00
#  0:14 started reading
#  4:49 started coding (reading 4:35)
# 14:26 made x,y overwrite mistake
#   also made a mess with getpos, readpos
# 16:58 could be solved
# 31:27 Fix: x,y overwrite (lost 14:25. yey)
# 32:56 made "0" vs 0 mistake
# 34:43-34:54 Fix "0" vs 0 (lost 1:58)
# star1 could be 17:24
# star2 could be 18:42 delta 1:18
#
# Even these numbers are very slow, others got 8m50 and 13m49 on star1