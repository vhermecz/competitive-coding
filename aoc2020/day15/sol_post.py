import collections, functools, operator, time

def gen(seq):
    idx = 1
    last = {}
    for i in seq[:-1]:
        yield i
        last[i]=idx
        idx+=1
    curr = seq[-1]
    while True:
        yield curr
        nxt = (idx-last.get(curr, 0))%idx
        last[curr]=idx
        idx+=1
        curr=nxt

ts=time.time()
for i, num in enumerate(gen([1,0,16,5,17,4])):
    if i==30000000-1:
        print(num)
        break

print(time.time()-ts)
# s1t @14:46 #1218 =1294
# s2t @16:00 #519 =573522
# damn, lost some time with silly bugs.
