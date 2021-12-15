import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield line

def flip(tiledata):
    s = len(tiledata)
    res = [[None]*s for i in range(s)]
    for r in range(s):
        for c in range(s):
            res[c][r] = tiledata[r][c]
    return res

def rotr90(tiledata):
    s = len(tiledata)
    res = [[None]*s for i in range(s)]
    for r in range(s):
        for c in range(s):
            res[c][s-1-r] = tiledata[r][c]
    return res

def rotator(tiledata):
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata
    tiledata = flip(tiledata)
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata
    tiledata = rotr90(tiledata)
    yield tiledata

def getside(tile, idx):
    s = ["", "", "", ""]
    for i in range(10):
        s[0] += tile[0][i]
        s[1] += tile[i][-1]
        s[2] += tile[-1][i]
        s[3] += tile[i][0]
    return s[idx]

def sides(tile):
    """
    TLBR
    """
    s = ["", "", "", ""]
    for i in range(10):
        s[0] += tile[0][i]
        s[1] += tile[i][-1]
        s[2] += tile[-1][10-1-i]
        s[3] += tile[10-1-i][0]
    return int(s[0], 2), int(s[1], 2), int(s[2], 2), int(s[3], 2)

def inv():
    res = {}
    for i in range(1024):
        bin = ['1' if (i//(2**n))%2 else '0' for n in range(10)]
        binr = bin[::-1]
        ir = int("".join(bin), 2)
        #print(i, ir, "".join(bin), "".join(binr))
        res[i]=ir
    return res

def inp2():
    idx = 0
    lines = list(inp())
    while True:
        while idx < len(lines) and lines[idx]=="":
            idx+=1
        if idx==len(lines):
            break
        line = lines[idx]
        idx+=1
        tn = int(line.split("Tile ")[1].strip(":"))
        data = []
        for i in range(10):
            data.append(['1' if ch=="#" else '0' for ch in lines[idx]])
            idx+=1
        side=sides(data)
        yield tn, side, data

invmap = inv() # 26
tiles = list(inp2()) # 27.40
tilemap = {}
for tile in tiles:
    tilemap[tile[0]] = tile

def alldir(invmap, sides):
    res = list(sides)
    for s in sides:
        res.append(invmap[s])
    return set(res)

def flipsides(invmap, sides):
    return tuple(invmap(i) for i in slides)

refs = collections.defaultdict(dict)
for t1idx, t1sides, tdata in tiles:
    for t2idx, t2sides, tdata in tiles:
        if t1idx!=t2idx and len(alldir(invmap, t1sides)&alldir(invmap, t2sides)):
            matchingside = [i for i in range(4) if t1sides[i] in alldir(invmap, t2sides)]
            if len(matchingside) != 1:
                print("FAKK")
            refs[t1idx][matchingside[0]] = t2idx

cs = collections.defaultdict(int)
sol=1
corners = []
for tidx, nb in refs.items():
    if len(nb)==2:
        sol*=tidx
        corners.append(tidx)
    cs[len(nb)]+=1

# s1 =29125888761511

PROBSIZE = 12

ctl = corners[0]
print(refs[ctl])
grid = [[None]*PROBSIZE for i in range(PROBSIZE)]
grid[0][0] = ctl
tdata = [[None]*PROBSIZE for i in range(PROBSIZE)]
tdata[0][0] = rotr90(tilemap[ctl][2]) if PROBSIZE==3 else tilemap[ctl][2] # pont jól áll
img = [[None]*8*PROBSIZE for i in range(8*PROBSIZE)]
for br in range(8):
    for bc in range(8):
        img[br][bc] = tdata[0][0][br+1][bc+1]
for r in range(PROBSIZE):
    for c in range(PROBSIZE):
        if r==0 and c==0:
            continue
        if c==0:
            basetileidx = grid[r-1][c]
            basetiledata = tdata[r-1][c]
            tomatch = getside(basetiledata, 2)
            attemptside = 0
            #upper match
        else:
            basetileidx = grid[r][c-1]
            basetiledata = tdata[r][c-1]
            tomatch = getside(basetiledata, 1)
            attemptside = 3
        found = False
        for candidtileidx in refs[basetileidx].values():
            candidatetiledata = tilemap[candidtileidx][2]
            for attempt in rotator(candidatetiledata):
                if getside(attempt, attemptside) == tomatch:
                    grid[r][c] = candidtileidx
                    tdata[r][c] = attempt
                    found = True
                    for br in range(8):
                        for bc in range(8):
                            img[r*8+br][c*8+bc] = attempt[br+1][bc+1]
                    break
            if found:
                break

for r in range(PROBSIZE*8):
    print("".join(img[r]).replace("1", "X").replace("0"," "))

sprite = ["                  # ", "#    ##    ##    ###", " #  #  #  #  #  #  "]

def isfindmonster(img, r, c):
    if r + len(sprite) >= len(img):
        return False
    if c + len(sprite[0]) >= len(img[0]):
        return False
    for rs, row in enumerate(sprite):
        row = sprite[rs]
        for cs, pixel in enumerate(row):
            if pixel == "#" and img[r+rs][c+cs] == '0':
                return False
    return True

def maskmonster(img, r, c):
    for rs, row in enumerate(sprite):
        row = sprite[rs]
        for cs, pixel in enumerate(row):
            if pixel == "#":
                img[r+rs][c+cs] = '2'

def maskall(img):
    for r in range(len(img)):
        for c in range(len(img[0])):
            if isfindmonster(img, r, c):
                maskmonster(img, r, c)

cnt = 0
for r in range(len(img)):
    for c in range(len(img[0])):
        if img[r][c] == '1':
            cnt+=1

print(cnt)

maskall(img)
img = rotr90(img)
maskall(img)
img = rotr90(img)
maskall(img)
img = rotr90(img)
maskall(img)
img = flip(img)
maskall(img)
img = rotr90(img)
maskall(img)
img = rotr90(img)
maskall(img)
img = rotr90(img)
maskall(img)

cnt = 0
for r in range(len(img)):
    for c in range(len(img[0])):
        if img[r][c] == '1':
            cnt+=1

print(cnt)

# s1 =x @35:18 #700
# =2264 too high @7:41:45
# s1 =2219  @1:50:18 #373
