# https://www.redblobgames.com/grids/hexagons/

import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        res = []
        idx = 0
        while idx < len(line):
            sidx = idx
            while idx < len(line) and line[idx]!='e' and line[idx]!='w':
                idx += 1
            idx += 1
            res.append(line[sidx:idx])
        yield res

paths = list(inp())

DELTA = {
    'e': (-1, 0),
    'se': (0, -1),
    'sw': (1, -1),
    'w': (1, 0),
    'nw': (0, 1),
    'ne': (-1, 1),
}

def dostep(cord, step):
    x0, y0 = cord
    dx, dy = DELTA[step]
    return (x0+dx, y0+dy)

def iterit(b):
    nbcs = collections.defaultdict(int)
    ds = DELTA.values()
    for pb in b:
        for d in ds:
            p = (pb[0]+d[0],pb[1]+d[1])
            nbcs[p]+=1
    nb = set()
    for p, nbc in nbcs.items():
        if p in b:
            if nbc == 1 or nbc == 2:
                nb.add(p)
        else:
            if nbc == 2:
                nb.add(p)
    return nb

poses = set([])

for path in paths:
    coord = (0,0)
    for step in path:
        coord = dostep(coord, step)
    if coord in poses:
        poses.remove(coord)
    else:
        poses.add(coord)

for i in range(100):
    poses = iterit(poses)

print(i, len(poses))

#print(len(poses))
