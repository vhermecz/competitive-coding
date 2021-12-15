def input():
    for line in open("input"):
        line = line.strip()
        yield int(line)

data = list(input())

def valid(subr, num):
    for i in range(len(subr)):
        for j in range(i+1, len(subr)):
            if subr[i]+subr[j]==num:
                return True
    return False

for i in range(len(data)-25):
    if not valid(data[i:i+25], data[i+25]):
        print(data[i+25])
        break

num=20874512
for i in range(len(data)):
    for j in range(i+1, len(data)):
        if sum(data[i:j+1])==num:
            print([data[i],data[j],data[i]+data[j]])




# 20874512 6.47
# 3012420 11.56
# 712. place to solveC