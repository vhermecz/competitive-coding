import collections, itertools

INFILE = 'test'
INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			yield row.strip().split("-")

def is_small_cave(node):
	return node.lower() == node

def solve0(graph, path, visited, twiced):
	#print(path, visited)
	if path[-1]=='end':
		yield path[::]
	else:
		for nxt in graph[path[-1]]:
			exception = False
			if nxt in visited and nxt != 'start' and not twiced:
				twiced = True
				exception = True
			if exception or not (nxt in visited):
				if is_small_cave(nxt) and not exception:
					visited.add(nxt)
				path.append(nxt)
				for res in solve0(graph, path, visited, twiced):
					yield res
				path.pop()
				if is_small_cave(nxt) and not exception:
					visited.remove(nxt)
			if exception:
				twiced = False

def solve(graph):
	for path in solve0(graph, ['start'], set(['start']), False):
		yield path

data = list(read_input(INFILE))
graph = collections.defaultdict(list)
for a, b in data:
	graph[a].append(b)
	graph[b].append(a)

#print(graph)
res = sorted(list(solve(graph)))

#for i in res:
#	print(','.join(i))

print(len(res))

# 00:16:20   1043 - 5178
# 00:21:50    591 - 130094


#timeline
# 0:30 6:00
# 0:41 start reading
# 1:30-1:45 copying 3rd example
# 3:50 started coding
# 8:30 star1 potential (8:35=8:00(base)+0:25(finish)+0:10(submit))
#   Error: path.pop()
#   Error: add edges both ways
#   Error: yield results
#   Error: copy yield results
#   Error: key error on double remove
#   Error: set('start') vs set(['start'])
# 16:50 start1 submit
# 17:23 started coding
# 19:02-19:27 Fix: adding/remong twice to visited => KeyError (lost 25s)
# 19:27-22:06 Fix: reset twiced (we are still in a loop dammit) (lost 2m39s)
# 22:20 start2 submit (5:30, could have been 2:51)
# star2 potential 11:26 (place#73)
