import collections
INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		return map(int, fp.read().strip().split(','))

data = list(read_input(INFILE))

s = 23432424243242
sp = 0
for t in range(min(data), max(data)+1):
	cs = 0
	for c in data:
		# cs += abs(c-t)
		cs += abs(c-t)*(abs(c-t)+1)/2
	if cs < s:
		s = cs
		sp = t

print(sp)
# 00:07:30   3063 - 326132
# 00:10:16   1878 - 88612508