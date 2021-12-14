# opened problem at 6:01
# working on borrowed machine (keyboard)
# readline struggle

def read_input(fname):
	with open(fname) as fp:
		nums = list(map(int, fp.readline().strip().split(",")))
		tickets = []
		while fp.readline()!='':
			ticket = []
			for i in range(5):
				row = fp.readline().strip().split(" ")
				row = filter(lambda x:x!='', row)
				row = list(map(int, row))
				ticket += row
			tickets.append(ticket)
		return nums, tickets

def winning(board):
	for i in range(5):
		if all(board[i*5+j] for j in range(5)):
			return True
	for i in range(5):
		if all(board[j*5+i] for j in range(5)):
			return True
	return False

def solve(nums, tickets, first):
	markers = []
	elim = [first] * len(tickets)
	for i in range(len(tickets)):
		markers.append([False]*25)
	for num in nums:
		for idx, ticket in enumerate(tickets):
			try:
				markers[idx][ticket.index(num)] = True
				if winning(markers[idx]):
					elim[idx] = True
					if all(elim):
						tot = sum(t for m, t in zip(markers[idx], ticket) if not m)
						return tot * num
			except ValueError:
				pass

nums, tickets = read_input("input")
print(solve(nums, tickets, True))
# 55770 - 21:19 1384
print(solve(nums, tickets, False))
# 2980 - 22:47 852
