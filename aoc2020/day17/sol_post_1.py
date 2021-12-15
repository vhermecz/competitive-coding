import collections, functools, operator, time

#7:12:30
#26:00 bad res
#34:00 good (nxt used selfpos instead of p)
#  lost 2-3 minutes explaining to bela

dim = 4
def inp():
    b = {}
    for ri, line in enumerate(open("input.txt")):
        line = line.strip()
        for ci, c in enumerate(line):
            if c=="#":
                b[tuple(([0]*(dim-2)) + [ri,ci])] = 1
    return b

def recomb(r, d):
    r=list(r)
    for a in r:
        for b in r:
            for c in r:
                for d in r:
                    yield (a,b,c,d)

def vadd(va,vb):
    return tuple(map(sum, zip(va,vb)))

def nxt(b, p):
    selfpos = tuple([0]*dim)
    ncnt = 0
    for d in recomb([-1,0,1], dim):
        if d != selfpos:
            ncnt += b.get(vadd(p,d),0)
    v = b.get(p, 0)
    return 1 if ((v==1 and 2<=ncnt<=3) or (v==0 and ncnt==3)) else 0

def it(b):
    nb = {}
    interesting = set()
    for p in b.keys():
        for d in recomb([-1,0,1], dim):
            interesting.add(vadd(p,d))
    for p in interesting:
        n = nxt(b,p)
        if n:
            nb[p]=1
    return nb

b=inp()
ts = time.time()
print([len(b), time.time()-ts])
for i in range(6):
    b = it(b)
    print([len(b), time.time()-ts])
