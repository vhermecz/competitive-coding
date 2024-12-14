import time
import numpy as np
from functools import reduce

INPUT = "input"

# transpiled from a1.rb via LLM
with open(INPUT, 'r') as file:
    data = [
        [
            [int(i) for i in value.split("=")[-1].split(",")]
            for value in line.strip().split(" ")
        ]
        for line in file
    ]

p = np.array(list(map(lambda d:d[0], data)))
v = np.array(list(map(lambda d:d[1], data)))
w,h = [101, 103] if INPUT=="input" else [11, 7]

def mul(values):
    return reduce(lambda x, y: x * y, values)

# transpiled from a1.rb via LLM
def quadrant_score(pos, w, h):
    filtered = [
        p for p in pos
        if p[0] != w // 2 and p[1] != h // 2
    ]
    grouped = {}
    for p in filtered:
        c, r = p
        v = (0 if c < w // 2 else 2) + (0 if r < h // 2 else 1)
        if v not in grouped:
            grouped[v] = []
        grouped[v].append(p)
    return [len(values) for values in grouped.values()]

def debug(pos, w, h):
    pos = set([tuple(v) for v in pos.tolist()])
    for r in range(h): #36, 77
        print("".join([
            " " if (c,r) not in pos else "*"
            for c in range(w)
        ]))

i = 0
while True:
    i += 1
    print(f"\r#{i}", end="", flush=True)
    p += v
    p[:, 0] %= w  # Apply modulus w to the first column
    p[:, 1] %= h  # Apply mo
#     if i == 100:
#         print()
#         debug(p, w, h)
    if i < 6492:  # 635, 1039, 1140, 1241, 1342
        continue
    if i %101 == 29:
        print()
        print(i)
        debug(p, w, h)
        time.sleep(1)
#     if i == 100:
#         print(mul(quadrant_score(p.tolist(), w, h)))
#         break

# Yeah, it repeats every w*h, and obviously I just missed it for a long time.

# 228457125
# 6493
