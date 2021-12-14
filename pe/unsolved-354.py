#ops
#	(3, 0)
#	(0, 3)
#	(1, 1)
#
#		=> a == b (mod3)
#
#dist
#	sqrt(a^2 + b^2 + ab)
#
#	450

import collections
vcnt = collections.defaultdict(int)

for a in range(10000):
	for b in range(a%3, 10000, 3):
		v = a*a + b*b + a*b
		vcnt[v] += 1

vals = vcnt.values()
for x in sorted(set(vals)):
	print x, vals.count(x)



