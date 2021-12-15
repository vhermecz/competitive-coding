def input(init):
    data = set(init)
    for line in open("input"):
        line = line.strip()
        #print("Reading:", line)
        if len(line)==0:
            yield data
            #print("returning", data)
            data = set(init)
            continue
        data = data & set(line)
        #print("updated to ", data)
    if len(data):
        yield data

# print(sum(len(data) for data in input()))

print(sum(len(data) for data in input("abcdefghijklmnopqrstuvwxyz")))
