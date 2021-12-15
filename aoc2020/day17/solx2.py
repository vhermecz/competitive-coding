import collections, functools, operator, time

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield [i for i in line]

def o(b, w, z, r, c):
    d = len(b)
    return not(w>=0 and z>=0 and r >= 0 and c >= 0 and w < d and z < d and r < d and c < d)

def v(b, w, dw, z, dz, r, dr, c, dc):
    if not o(b,w+dw,z+dz,r+dr,c+dc):
        return b[w+dw][z+dz][r+dr][c+dc]
    else:
        return "."

def ns(b, w, z, r, c):
    n = ""
    for dw in [-1,0,1]:
        for dz in [-1,0,1]:
            for dr in [-1,0,1]:
                for dc in [-1,0,1]:
                    if not(dr==0 and dc==0 and dz==0 and dw==0):
                        n += v(b, w, dw, z, dz, r, dr, c, dc)
    return n

def ru(b, w, z, r, c):
    n = ns(b,w,z,r,c)
    v = b[w][z][r][c]
    if v == "#":
        return "#" if 2<=n.count("#")<=3 else "."
    else:
        return "#" if n.count("#")==3 else "."

def it(b):
    d = len(b)
    n = [[[[v for v in r] for r in z] for z in w] for w in b]
    for w in range(d):
        for z in range(d):
            for r in range(d):
                for c in range(d):
                    n[w][z][r][c] = ru(b,w,z,r,c)
    return n

def cnt(b):
    d = len(b)
    cn = 0
    for w in range(d):
        for z in range(d):
            for r in range(d):
                for c in range(d):
                    if b[w][z][r][c] == "#":
                        cn += 1
    return cn

def prefill(b):
    d = len(b)
    r = [[[["." for c in range(d)] for r in range(d)] for z in range(d)] for w in range(d)]
    r[d//2][d//2] = b
    return r

def grow(b):
    d = len(b)+2
    res = [[[["." for c in range(d)] for r in range(d)] for z in range(d)] for w in range(d)]
    for w in range(d):
        for z in range(d):
            for r in range(d):
                for c in range(d):
                    if not o(b,w-1,z-1,r-1,c-1):
                        res[w][z][r][c] = b[w-1][z-1][r-1][c-1]
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

ts = time.time()
for i in range(6):
    b = it(grow(b))
    print([cnt(b), time.time()-ts])


# ERR1: Did not understand the change of the board (the example moved the board to focus on the changing region)
# ERR2: Had a var redefinition in count (using c both as count and column_idx) (bug copied from day11)
# star1 @47:23 #2074 =232
# star2 @54:32 #1902 =1620 t=42s
