def read_input():
	for row in open("input"):
		row = row.strip().split()
		row[1] = int(row[1])
		yield row

# fw = 0
# dp = 0
# for cmd, param in read_input():
# 	if cmd == "forward":
# 		fw += param
# 	elif cmd == "up":
# 		dp -= param
# 	else:
# 		dp += param
# print(fw,dp,fw*dp)
#star1 (1815, 908, 1648020)
# 00:02:59   974

fw = 0
dp = 0
aim = 0

for cmd, param in read_input():
	if cmd == "forward":
		fw += param
		dp += aim * param
	elif cmd == "up":
		aim -= param
	else:
		aim += param

print(fw,dp,fw*dp)
#star2 (1815, 969597, 1759818555)
# 00:05:08   947

# 2   00:02:59   974      0   00:05:08   947      0

