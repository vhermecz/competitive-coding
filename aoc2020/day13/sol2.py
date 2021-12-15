import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield line

num, primesraw = inp()

#primesraw = "67,7,59,61"
primes = [(int(x), idx+1) for idx, x in enumerate(primesraw.split(",")) if x!='x']
#primes = [(821, 20), (463, 51)]
num = int(num)

print(num)

c = -1
b = 0
for p, idx in primes:
    r = ((p - (num%p)) % p) + num
    print([p, r/p, r%p])
    if c==-1 or r < c:
        c=r
        b=p

print(c)
print((c-num)*b)

#sol2
print(primes)
print(["start"])
def solve(primes):
    print(primes)
    if len(primes)==1:
        return primes[0][0]-primes[0][1]
    c = solve(primes[0:-1])
    d = functools.reduce(operator.mul, [p for p, _ in primes[0:-1]])
    p, idx = primes[-1]
    idx = idx % p
    print([c,d])
    while True:
        if c%p==p-idx:
            break
        c+=d
    return c

c=solve(sorted(primes))

# 67*7*59*61 = 1687931
# 1202161486
# 5876813119
print(c+1)
for p, idx in primes:
    print([p, idx, c%p])
