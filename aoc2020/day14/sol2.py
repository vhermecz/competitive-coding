import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        var, val = line.split(" = ")
        var = var.strip("]").split("[")
        yield var,val

def expand(mask):
    if mask.count("X") == 0:
        yield int(mask, 2)
    else:
        for res in expand(mask.replace("X", "0", 1)):
            yield res
        for res in expand(mask.replace("X", "1", 1)):
            yield res

mem = collections.defaultdict(int)
mask_float = 0
mask_over = 0
for var, val in inp():
    if var[0] == "mask":
        mask_float = int(val.replace("1", "0").replace("X", "1"), 2)
        mask_float_values = list(expand(val.replace("1", "0")))
        mask_over = int(val.replace("X", "0"), 2)
    else:
        addr = int(var[1]) | mask_over
        for float_value in mask_float_values:
            addr = (addr & ~mask_float) | float_value
            mem[addr] = int(val)

print(sum(mem.values()))

# 10892669308191 bad
# 10885823581193 ~(had a missing negation)
# star1 @14:07 #748
# 257994611740 bad 28:30
# 3816594901962 list(mask_float_values was exhausted after first write, subsequent writes skipped due to this)
# star2 @55:50 #2160 (would have been28:30 haelnembaszom-TM)
