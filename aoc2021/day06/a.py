import collections
INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		return map(int, fp.read().strip().split(','))

data = list(read_input(INFILE))
cnt = [0]*9
for num in data:
	cnt[num]+=1

for i in range(256):
	zer = cnt[0]
	cnt = cnt[1:] + [zer]
	cnt[6]+=zer


print(sum(cnt))

#1st 372300 - 7m20s - 1723
#2nd 1675781200288 -7m41s - 240

# lost 35sec on forgetting cnt[6]+=zer (+ inlining cnt[0] in line above)
# lost 30sec on `fp.read.strip()` missing parens
