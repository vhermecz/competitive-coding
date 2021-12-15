import collections, functools, operator, time, random

# def inp():
#     for line in open("input.txt"):
#         line = line.strip()
#         yield line

inp = "253149867"
inp = "389125467"
data = list(map(int, inp))
sdata = list(data)
idx = 0

data += list(range(max(data)+1,max(data)+1+1000-len(data)))

ts = time.time()

# for j in range(1000):
#     _ = data.index(random.randint(1, 1000000-1))

for i in range(600):
    ndata = data[idx:] + data[:idx]
    pick = ndata[1:4]
    ndata[1:4] = []
    target = ndata[0]-1
    if target < min(sdata):
        target = max(sdata)
    while target in pick:
        target = target - 1
        if target < min(sdata):
            target = max(sdata)
    target_pos = ndata.index(target)
    ndata[target_pos+1:target_pos+1] = pick
    print([i, ndata[0], [pick], target, (target_pos+3+i)%len(data)])
    data = ndata
    idx = 1

#print([i+1, data])
idx = data.index(1)
res = data[idx+1:] + data[:idx]

res = "".join(map(str,res))

#print(res)
print(time.time()-ts)

# 23     130   1594  ** (after 42 minutes)
# 23     472   2086  ** (after 61 minutes)
