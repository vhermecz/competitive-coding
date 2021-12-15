import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield [i for i in line]

def o(b, z, r, c):
    return not(z>=0 and r >= 0 and c >= 0 and z < len(b) and r < len(b[0]) and c < len(b[0][0]))

def v(b, z, dz, r, dr, c, dc):
    if not o(b,z+dz,r+dr,c+dc):
        return b[z+dz][r+dr][c+dc]
    else:
        return "."

def ns(b, z, r, c):
    n = ""
    for dz in [-1,0,1]:
        for dr in [-1,0,1]:
            for dc in [-1,0,1]:
                if not(dr==0 and dc==0 and dz==0):
                    n += v(b, z, dz, r, dr, c, dc)
    return n

def ru(b, z, r, c):
    n = ns(b,z,r,c)
    v = b[z][r][c]
    if v == "#":
        return "#" if 2<=n.count("#")<=3 else "."
    else:
        return "#" if n.count("#")==3 else "."

def it(b):
    n = [[[v for v in r] for r in z] for z in b]
    for z in range(len(b)):
        for r in range(len(b[0])):
            for c in range(len(b[0][0])):
                n[z][r][c] = ru(b,z,r,c)
    return n

def cnt(b):
    cn = 0
    for z in range(len(b)):
        for r in range(len(b[0])):
            for c in range(len(b[0][0])):
                if b[z][r][c] == "#":
                    cn += 1
    return cn

def prefill(b):
    d = len(b)
    r = [[["." for c in range(d)] for r in range(d)] for z in range(d)]
    r[d//2] = b
    return r

def grow(b):
    d = len(b)+2
    res = [[["." for c in range(d)] for r in range(d)] for z in range(d)]
    for z in range(d):
        for r in range(d):
            for c in range(d):
                if not o(b,z-1,r-1,c-1):
                    res[z][r][c] = b[z-1][r-1][c-1]
    return res

b = prefill(list(inp()))

def pb(b):
    d = len(b)
    for idx, z in enumerate(b):
        print(f'z={idx-d//2}')
        for r in z:
            print("".join(r))
    print(cnt(b))
    print
    input()

for i in range(6):
    #pb(b)
    b = grow(it(grow(b)))

print(cnt(b))
