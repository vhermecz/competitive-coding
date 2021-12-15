import collections, functools, operator



def inp():
    idx = 0
    data = collections.defaultdict(list)
    for line in open("input.txt"):
        line = line.strip()
        if line.startswith("Player"):
            idx = int(line[:-1].split(" ")[1])-1
        elif line!="":
            print(line)
            data[idx].append(int(line))
    data = [l[::-1] for l in data.values()]
    return data

p1s, p2s = inp()

def play_round(p1s, p2s):
    p1s = list(p1s)
    p2s = list(p2s)
    seenset = set()
    while len(p1s) and len(p2s):
        cur = (tuple(p1s), tuple(p2s))
        if cur in seenset:
            return ([-1], [])
        seenset.add(cur)
        print([p1s,p2s])
        p1 = p1s.pop()
        p2 = p2s.pop()
        if p1 > p2:
            p1s.insert(0, p1)
            p1s.insert(0, p2)
        else:
            p2s.insert(0, p2)
            p2s.insert(0, p1)
    return p1s, p2s



print([p1s,p2s])

w = p1s if len(p1s) else p2s

r = sum((i+1)*v for i, v in enumerate(w))
print(r)

#33421