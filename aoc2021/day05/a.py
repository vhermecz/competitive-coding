# start at 18:27:30
# finish at 18:40:23
import collections

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			row = row.strip().split(' -> ')
			yield tuple(tuple(map(int, item.split(','))) for item in row)


def interpolate(start, end):
	start, end = sorted([start, end])
	if start[0]==end[0]:
		st, en = sorted([start[1], end[1]])
		for p in range(st, en+1):
			yield (start[0], p)
	elif start[1]==end[1]:
		st, en = sorted([start[0], end[0]])
		for p in range(st, en+1):
			yield (p, start[1])
	elif end[1] > start[1]:
		for i in range(end[1]-start[1]+1):
			yield (start[0]+i, start[1]+i)
	else:
		for i in range(start[1]-end[1]+1):
			yield (start[0]+i, start[1]-i)



matrix = collections.defaultdict(int)
for start, end in read_input('input'):
	for point in interpolate(start, end):
		matrix[point] += 1

print len(filter(lambda x:x>1, matrix.values()))

#1st star 9:07 - 3990
#2nd star 12:44 - 21305

#print(list(read_input('test')))
#	781,721 -> 781,611