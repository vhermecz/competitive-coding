data = open("input.txt").read()

print(data.count("(")-data.count(")"))

level = 0
for idx, c in enumerate(data):
    level += 1 if c=='(' else -1
    if level==-1:
        print(idx+1)
        break