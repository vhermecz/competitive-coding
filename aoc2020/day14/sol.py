import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        var, val = line.split(" = ")
        var = var.strip("]").split("[")
        yield var,val


mem = collections.defaultdict(int)
mask_mask = 0
mask_over = 0
for var, val in inp():
    if var[0] == "mask":
        mask_mask = ~int(val.replace("1", "0").replace("X", "1"), 2)
        mask_over = int(val.replace("X", "0"), 2)
        print([val.replace("1", "0").replace("X", "1")])
        print([val.replace("X", "0")])
        print([mask_mask, mask_over])
    else:
        val = int(val)
        print(val)
        val = (val & ~mask_mask) | mask_over
        print(val)
        mem[int(var[1])] = val

print(sum(mem.values()))

# 10892669308191 bad