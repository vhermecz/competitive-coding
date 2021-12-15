import collections, functools, operator, sys, time

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield line

def inp2():
    lines = list(inp())
    idx = 0
    rules = {}

    while lines[idx] != "":
        rid, rdatums = lines[idx].split(": ")
        rdata = []
        for rdatum in rdatums.split(" | "):
            rdata.append([item[1] if item[0]=='"' else int(item) for item in rdatum.split(" ")])
        rules[int(rid)] = rdata
        idx += 1
    idx += 1
    sentences = []
    while idx < len(lines):
        sentences.append(lines[idx])
        idx+=1
    return rules, sentences

rules, sentences = inp2()
rules[8] = [[42], [42,8]]
rules[11] = [[42,31], [42,11,31]]

def trymatch(rules, s, rid, idx):
    if type(rid) == str:
        if idx < len(s) and s[idx] == rid:
            return [idx+1]
        else:
            return []
    else:
        res = []
        for rule in rules[rid]:
            nidxs = [idx]
            for nrid in rule:
                x = []
                for nidx in nidxs:
                    x.extend(trymatch(rules, s, nrid, nidx))
                nidxs = x
            res.extend(nidxs)
        return res

cnt = 0
ts = time.time()
for sentence in sentences:
    if len(sentence) in trymatch(rules, sentence, 0, 0):
        cnt+=1

print(time.time()-ts)
print(cnt)

# 11-17.30 : non array based
# @39:37 #1003 =132
# @41:40 #293 =306
# 28:40 for top100
