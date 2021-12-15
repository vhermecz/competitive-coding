import sys

def input():
    for idx, line in enumerate(open("input")):
        line = line.strip()
        base, others = line.split(" bags contain ", 1)
        if others != "no other bags.":
            for other in others.split(", "):
                num, adj, color, bag = other.split(" ", 3)
                real = adj + " " + color
                yield (base, real, int(num))
        else:
            yield (base, None, None)


edges = list()
node = set()
for a, b, c in input():
    if b:
        edges.append((a,b,c))
    node.add(a)

ref = {}
for k in node:
    ref[k]=0

def getcount(color):
    if color is None:
        return 0
    res = 0
    for outcol, incol, cnt in edges:
        if outcol == color:
            res += cnt * (getcount(incol) + 1)
    return res

ref["shiny gold"] = 1

res = sum(ref.values())

while True:
    for a, b, _ in edges:
        ref[a] = ref[a] or ref[b]
    resn = sum(ref.values())
    if res == resn:
        break
    res = resn

print(res-1)
# 21.5m

print(getcount("shiny gold"))
# 27m
