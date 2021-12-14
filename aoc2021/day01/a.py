def read_input():
	for row in open("input"):
		yield int(row.strip())

def count_increase(series):
	last = None
	count = 0
	for row in series:
		if last is not None and row > last:
			count += 1
		last = row

def agg3(series):
	last2 = None
	last = None
	count = 0
	for row in series:
		if last is not None and last2 is not None:
			yield row + last + last2
		last2 = last
		last = row

def count_increase(series):
	last = None
	count = 0
	for row in series:
		if last is not None and row > last:
			count += 1
		last = row
	return count

print(count_increase(read_input()))
print(count_increase(agg3(read_input())))
