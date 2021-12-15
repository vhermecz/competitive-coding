import collections, functools, operator, time



def inp():
    idx = 0
    data = collections.defaultdict(list)
    for line in open("input.txt"):
        line = line.strip()
        if line.startswith("Player"):
            idx = int(line[:-1].split(" ")[1])-1
        elif line!="":
            data[idx].append(int(line))
    data = [l[::-1] for l in data.values()]
    return data

p1s, p2s = inp()

cache = {}

def play_round(p1s, p2s):
    gm = (tuple(p1s), tuple(p2s))
    #if gm in cache:
    #    return cache[gm]
    #print([p1s,p2s])
    p1s = list(p1s)
    p2s = list(p2s)
    seenset = set()
    while len(p1s) and len(p2s):
        cur = (tuple(p1s), tuple(p2s))
        if cur in seenset:
            cache[gm] = ([-1], [])
            return ([-1], [])
        seenset.add(cur)
        #print([p1s,p2s])
        p1 = p1s.pop()
        p2 = p2s.pop()
        win = p1>p2
        if p1 <= len(p1s) and p2 <= len(p2s):
            #print(p1,p2)
            sub = play_round(p1s[-p1:], p2s[-p2:])
            win = len(sub[0])>0
        if win:
            p1s.insert(0, p1)
            p1s.insert(0, p2)
        else:
            p2s.insert(0, p2)
            p2s.insert(0, p1)
    #cache[gm] = (tuple(p1s), tuple(p2s))
    return p1s, p2s

ts = time.time()
p1s,p2s = play_round(p1s,p2s)

print(time.time()-ts)

print([p1s,p2s])

w = p1s if len(p1s) else p2s

r = sum((i+1)*v for i, v in enumerate(w))
print(r)

# s1 =33421 @10:28 #1186
# 32396 wrong (subgame was played with one extra item. duhh. test did not fail on it)
# s2 =33651 @34:37 #603