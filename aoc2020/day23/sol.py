import collections, functools, operator, time

# def inp():
#     for line in open("input.txt"):
#         line = line.strip()
#         yield line

inp = "253149867"
#inp = "389125467"
data = list(map(int, inp))
sdata = list(data)
idx = 0

data += list(range(max(data)+1,max(data)+1+1000000-len(data)))

ts = time.time()

for i in range(20):
    #print([i, data])
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
    ndata[ndata.index(target)+1:ndata.index(target)+1] = pick
    data = ndata
    idx = 1

idx = data.index(1)
res = data[idx+1:] + data[:idx]

res = "".join(map(str,res))

#print(res)
print(time.time()-ts)
