import collections, functools, operator, time

#7:12:30
#26:00 bad res
#34:00 good (nxt used selfpos instead of p)
#  lost 2-3 minutes explaining to bela

dim = 4
def inp():
    b = set()
    for ri, line in enumerate(open("input.txt")):
        line = line.strip()
        for ci, c in enumerate(line):
            if c=="#":
                b.add(tuple(([0]*(dim-2)) + [ri,ci]))
    return b

def recomb(r, d):
    r=list(r)
    for a in r:
        for b in r:
            for c in r:
                for d in r:
                    yield (a,b,c,d)

def vadd(va,vb):
    return (va[0]+vb[0],va[1]+vb[1],va[2]+vb[2],va[3]+vb[3])
    #return tuple(map(sum, zip(va,vb)))

def nxt(b, p, ds):
    selfpos = tuple([0]*dim)
    ncnt = 0
    for d in ds:
        if d != selfpos:
            ncnt += vadd(p,d) in b
    v = int(p in b)
    return 1 if ((v==1 and 2<=ncnt<=3) or (v==0 and ncnt==3)) else 0

def it(b):
    nb = set()
    seen = set()
    ds = list(recomb([-1,0,1], dim))
    for pb in b:
        for d in ds:
            p = vadd(pb,d)
            if p in seen:
                continue
            seen.add(p)
            if nxt(b,p,ds):
                nb.add(p)
    return nb

b=inp()
ts = time.time()
print([len(b), time.time()-ts])
for i in range(6):
    b = it(b)
    print([len(b), time.time()-ts])

# t 6.98 - initial map based (only living cells stored in map with value 1)
#   uses 2-phase eval. 1st phase collects positions to calc (1-dist neight of living), 2nd phase evad positions from 1st
# t 6.11 - dont recalc recomb for each position
# t 3.08 - inline vadd with direct 4dim addition
# t 2.76 - using set instead of map for board
# t 2.68 - originally had 2 passes, first to collect positions
