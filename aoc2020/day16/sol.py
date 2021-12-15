import collections, functools, operator

def inp():
    st = 0
    rule = {}
    my = None
    nearby = []
    for line in open("input.txt"):
        line = line.strip()
        if st == 0:
            if line == "":
                st=1
                continue
            field, ranges = line.split(": ")
            ranges = [tuple(map(int, range_.split("-"))) for range_ in ranges.split(" or ")]
            rule[field] = ranges
        if st == 1:
            if line == "":
                st=2
                continue
            if line == "your ticket:":
                continue
            my = list(map(int, line.split(",")))
        if st == 2:
            if line == "nearby tickets:":
                continue
            nearby.append(list(map(int, line.split(","))))
    return (rule, my, nearby)

def is_valid_num_(num, rules):
    for name, ranges in rules.items():
        for range_ in ranges:
            if range_[0] <= num <= range_[1]:
                yield name
    return

def is_valid_num(num, rules):
    return list(is_valid_num_(num, rules))


rules, my, nearbys = inp()

invalidsum = 0
inv = set()
for idx, nearby in enumerate(nearbys):
    for num in nearby:
        if len(is_valid_num(num, rules))==0:
            invalidsum += num
            inv.add(idx)

print(invalidsum)

valids = [my]
for idx, nearby in enumerate(nearbys):
    if idx not in inv:
        valids.append(nearby)

ranges = collections.defaultdict(set)
for idx in range(len(rules)):
    vs = set(rules.keys())
    for ticket in valids:
        vs = vs & set(is_valid_num(ticket[idx], rules))
    ranges[idx] = vs

sol = {}
while len(ranges):
    candidates = sorted([(len(range), idx) for idx, range in ranges.items()])
    clen, cidx = candidates[0]
    if clen == 1:
        sol[cidx] = next(iter(ranges[cidx]))
        del ranges[cidx]
        for range in ranges.values():
            range.remove(sol[cidx])
    else:
        print("BACKTRACK")
        break

res = 1
for idx, field in sol.items():
    if field.startswith("departure"):
        res *= my[idx]

print(res)

# s1 @16:32 #1418 =23044
# s2 @37:45 #685 =3765150732757
# lost a few minutes with not searching for set functions names (update, remove)
# starting with or-ing field ranges together instead of and-ing them
# was smart to assume no backtrack is needed
