import collections, itertools

INFILE = 'test'
#INFILE = 'input'

def read_input(fname):
	with open(fname) as fp:
		for row in fp:
			yield row.strip()


OPEN = "[{<("

SCORE = {
	')': 3,
	']': 57,
	'}': 1197,
	'>': 25137,
	None: 0,
}

AUTOSCORE = {
	')': 1,
	']': 2,
	'}': 3,
	'>': 4,
}

REV = {
	'(':')',
	'[':']',
	'{':'}',
	'<':'>',
}

def solve_line(data):
	stack = []
	for item in data:
		if item in OPEN:
			stack.append(item)
		elif len(stack) > 0:
			back = stack.pop()
			if REV[back] != item:
				return item
	score = 0
	for item in stack: #[::-1]:
		score *= 5
		score += AUTOSCORE[REV[item]]
	#print(score, data, ''.join([REV[item] for item in stack]))
	return score

def solve(data):
	sum = 0
	items = []
	for row in data:
		res = solve_line(row)
		if type(res)==int:
			items.append(res)
		else:
			sum += SCORE[res]
	items = sorted(items)
	return sum, items[len(items)//2]


data = list(read_input(INFILE))
res = solve(data)

print(res)
# 00:12:57   2497 - 392139
# 00:20:41   1884 - 4001832844

"""
FOR FUCK SAKE! Dont wanna talk about it. This was beyond lame
timeline
vid   comp note
0:42  0:00 start
0:53  0:11 download test
0:57  0:15 start watcher, start reading
3:08  2:26 start coding
4:25  3:43 line solver (with missing reverse)
5:42  5:00 first possible time test could be right
Errors
5:53  5:11 Fix: used push() instead of append() yeah, go javascript
6:14  5:32 Fix: not handling empty stack (incomplete)
11:02 10:20 after some debugging sending in the wrong result. why not? :P
12:36 11:52 finally realizing reverse is missing (after a 20sec stare)
13:08 12:26 completing the rev
13:21 12:39 FinalFix:forgot to reverse item popped from stack
13:40 12:58 star1
14:34 13:52 start coding
16:06 15:24 first possible time
Errors
17:13 16:31 Fix: Collect list of scores instead of sum
20:20 19:38 Fix: reversing the stack before scoring
21:xx 20:xx attempt to eyeball middle from list of ~32 items :P lol
21:13 20:31 FinalFix: pick mid one (was eyeballing)
21:17 20:35 result
21:24 20:42 star2
- submit middle value
- reverse the stack

star1-potential 5:42 = 5:00(first)+0:32(rev)+0:10(submit)
star1-reading   2:11
star1-debug     7:16
star2-potential 2:56 = 2:26(first)+0:20(getmid)+0:10(submit)
star2-reading   0:50
star2-debug     4:12   
total-potential 8:38
total-debug     11:28
"""
