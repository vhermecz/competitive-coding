import collections

def read_input():
	for row in open("input"):
		row = row.strip()
		yield list(row)

data = zip(*read_input())
gam = ""
eps = ""
for pos in data:
	c = collections.Counter(pos)
	gam += ['0','1'][c['1']>c['0']]
	eps += ['0','1'][c['1']<c['0']]
gam = int(gam,2)
eps = int(eps,2)
print(gam*eps)
#2595824
#00:06:38  1197 

def iter(data, pos, most):
	if len(data)==1:
		return data
	fltr = [item[pos] for item in data]
	cnt = collections.Counter(fltr)
	if not most:
		keeper = ['0','1'][cnt['1']>=cnt['0']]
	else:
		keeper = ['0','1'][cnt['1']<cnt['0']]
	res= [item2 for item, item2 in zip(fltr, data) if item == keeper]
	return res

data = list(read_input())
gam = data
eps = data
for pos in range(len(data[0])):
	gam = iter(gam, pos, True)
	eps = iter(eps, pos, False)

gam = ''.join(gam[0])
eps = ''.join(eps[0])

gam = int(gam,2)
eps = int(eps,2)
print(gam*eps)
#2135254
#00:23:15  1383    