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

def it(b):
    selfpos = tuple([0]*dim)
    ds = list(recomb([-1,0,1], dim))
    nbcs = collections.defaultdict(int)
    for pb in b:
        #nbcs[pb]+=1000
        for d in ds:
            p = (pb[0]+d[0],pb[1]+d[1],pb[2]+d[2],pb[3]+d[3])  # vadd(pb,d)
            if d != selfpos:
                nbcs[p]+=1
                
    stat = collections.defaultdict(int)
    nb = set()
    for p, nbc in nbcs.items():
        #stat[nbc]+=1
        #if nbc<=3 and nbc==3 or nbc==1002 or nbc==1003:
        #if nbc<=3 and (nbc==3 or (nbc==2 and p in b)):
        if nbc==3 or (nbc==2 and p in b):
        #if nbc==3 or nbc==1002 or nbc==1003:
            #stat[nbc]+=1
            nb.add(p)
    #print(sorted(stat.items()))
    return nb

b=inp()
ts = time.time()
print([len(b), time.time()-ts])
for i in range(6):
    b = it(b)
    print([len(b), time.time()-ts])

print(len(b))

# t 6.98 - initial map based (only living cells stored in map with value 1)
#   uses 2-phase eval. 1st phase collects positions to calc (1-dist neight of living), 2nd phase evad positions from 1st
# t 6.11 - dont recalc recomb for each position
# t 3.08 - inline vadd with direct 4dim addition
# t 2.76 - using set instead of map for board
# t 2.68 - originally had 2 passes, first to collect positions
# t 0.28 - Bela-trick
# t 0.26 - inline vadd
# t 0.25 - avoid p in b (in c it is not faster. (3 or==) vs (2 or== + in)
# meanwhile: C is 0.021ms
