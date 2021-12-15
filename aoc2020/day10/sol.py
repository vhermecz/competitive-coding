import collections, functools, operator

def input():
    for line in open("input.txt"):
        line = line.strip()
        yield int(line)

def fib3(n):
    a=b=1
    c=2
    res = [a,b,c]
    for _ in range(n):
        a,b,c = b,c,a+b+c
        res.append(c)
    return res

def rle1(delta):
    cnt = 0
    for i in delta:
        if i == 1:
            cnt += 1
        if i == 3:
            yield cnt
            cnt = 0
    if cnt:
        yield cnt

data = sorted(input())
data = [0] + data + [data[-1]+3]
delta = [data[i+1]-data[i] for i in range(len(data)-1)]
deltac = collections.Counter(delta)
print(deltac)
print(deltac.get(1)*deltac.get(3))
rle = list(rle1(delta))
print(delta)
print(rle)
fib = fib3(100)
print(functools.reduce(operator.mul, map(fib.__getitem__, rle)))
#0 published
#17.30 start
#27.31 sol1   10min
#36.17 how many way to sum from 1..3
#39.32 fib3
#43.56 sol2   26min comeooooon
