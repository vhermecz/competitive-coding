import collections, functools, operator, time

def gen(seq):
    idx = 0
    cnt = collections.defaultdict(int)
    last = {}
    for i in seq[:-1]:
        yield i
        cnt[i]+=1
        last[i]=idx
        idx+=1
    curr = seq[-1]
    while True:
        yield curr
        if cnt[curr] == 0:
            nxt = 0
        else:
            nxt=idx-last[curr]
        cnt[curr]+=1
        last[curr]=idx
        idx+=1
        curr=nxt

ts=time.time()
for i, num in enumerate(gen([1,0,16,5,17,4])):
    if i==30000000-1:
        print(num)
        break

print(time.time()-ts)
# s1t @14:46 #1218
# s2t @16:00 #519
# damn, lost some time with silly bugs.
