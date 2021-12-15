import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        words1, words2 = line.split(" (contains ")
        secrets = words1.split(" ")
        plains = words2[:-1].split(", ")
        yield secrets, plains

data = list(inp())

todo = set(w for _, i in data for w in i)
decode = {}

def remainder(secrets, decode):
    res = []
    for secret in secrets:
        if secret in decode.values():
            continue
        res.append(secret)
    return res


while len(todo):
    for meaning in todo:
        candidate = None
        for secrets, words in data:
            if meaning in words:
                remains = set(remainder(secrets, decode))
                if candidate is None:
                    candidate = remains
                else:
                    candidate = candidate & remains
        if len(candidate) == 1:
            decode[meaning] = list(candidate)[0]
            todo.remove(meaning)
            break

print(decode)
safes = set()
for secrets, words in data:
    safes |= set(remainder(secrets, decode))

print(safes)
cnt=0
for secrets, words in data:
    for secret in secrets:
        if secret in safes:
            cnt+=1

print(cnt)

#1942