import collections, functools, operator, time

# def inp():
#     for line in open("input.txt"):
#         line = line.strip()
#         yield line

inp = "253149867"
#inp = "389125467"

data = list(map(int, inp))
data += list(range(max(data)+1,max(data)+1+1000000-len(data)))
#data += list(range(max(data)+1,max(data)+1+20-len(data)))

#print(data)

def dbg(data):
    idx = 0
    cur = data[0]
    res = [1]
    while cur != 0 and idx < len(data):
        res.append(cur+1)
        cur = data[cur]
        idx += 1
    print(res)

ll = [None]*len(data)
for i in range(len(data)):
    ll[data[i]-1] = data[(i+1)%len(data)]-1

cur = data[0]-1
data = ll

ts = time.time()
for i in range(10000000):
    if i%100000==0:
        print(i)
    #dbg(data)
    nxt = data[data[data[data[cur]]]]
    dest = cur 
    while dest == cur or dest == data[cur] or dest == data[data[cur]] or dest == data[data[data[cur]]]:
        dest = (dest+len(data)-1) % len(data)
    #print([cur+1, nxt+1, dest+1])
    data[data[data[data[cur]]]] = data[dest]
    data[dest] = data[cur]
    #print(cur, nxt)
    #data[cur] = nxt
    #cur = nxt
    cur = data[cur] = nxt   # WTF why is this wrong?

#dbg(data)
#print(list(enumerate(data)))

print((1+data[0])*(1+data[data[0]]))

print(time.time()-ts)

# 149244794000 too low
# 149245887792 too low
# 505334281774 fsck
