import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield [i for i in line]

def o(b, r,c):
    return not(r >= 0 and c >= 0 and r < len(b) and c < len(b[0]))

def v(b, r, dr, c, dc):
    if not o(b,r+dr,c+dc):
        return b[r+dr][c+dc]
    else:
        return "."

def vl(b, r, dr, c, dc):
    i = 1
    while not o(b,r+i*dr,c+i*dc):
        v_ = v(b,r,i*dr,c,i*dc)
        if v_ != ".":
            return v_
        i+=1
    return "."

def ns(b, r, c):
    n = ""
    for dr in [-1,0,1]:
        for dc in [-1,0,1]:
            if not(dr==0 and dc==0):
                n += vl(b, r, dr, c, dc)
    return n

def ru(b, r, c):
    n = ns(b,r,c)
    v = b[r][c]
    if v == ".":
        return "."
    if v == "L" and n.count("#")==0:
        return "#"
    if v == "#" and n.count("#")<5:  # was 4
        return "#"
    return "L"

def it(b):
    n = [[v for v in r] for r in b]
    for r in range(len(b)):
        for c in range(len(b[0])):
            n[r][c] = ru(b,r,c)
    return n

def cnt(b):
    c = 0
    for r in range(len(b)):
        for c in range(len(b[0])):
            if b[r][c] == "#":
                c += 1
    return c

b = list(inp())
bl = []

def flat(b):
    return "".join(["".join(r) for r in b])

def pb(b):
    for r in b:
        print("".join(r))
    print
    input()

while flat(b) != flat(bl):
    print(flat(b).count("#"))
    bl = b
    b = it(b)

print(flat(b).count("#"))

#00:00 start
#22:09 first solution (1359th, 03:03 fastest, 08:31 slowest)
#28:00 fuckup (first visible SEAT! not person)
#40:22 fixed (1553th, 04:27 fastest, 14:06 slowest)
