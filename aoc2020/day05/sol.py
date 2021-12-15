seats = sorted(int(line.strip().translate("".maketrans("FBLR", "0101")), 2) for line in open("input"))

print(max(seats))
print(set(range(min(seats), max(seats)))-set(seats))
