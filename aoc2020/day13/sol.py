import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield line

num, primesraw = inp()

#primesraw = "67,x,7,59,61"
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
mp, pidx = max(primes)
print(mp)
c = mp-pidx+99999999907266
c = 100023502637302
c = 192095+99999999907266
#c = (100000000000000//mp)*mp-pidx
# 100000000000000
#c=100146201715368
#c=100327113145739
#1615033136751203
print(c)
try:
    while True:
        good=True
        d=821*463
        for p, idx in primes:
            if c%p!=p-idx:
                good=False
                break
        if good:
            break
        c+=mp
except KeyboardInterrupt:
    pass

# 67*7*59*61 = 1687931
# 1202161486
# 5876813119
print(c+1)
for p, idx in primes:
    print([p, idx, c%p])


# b = n1*p1-o1
# n1*p1-o1 == n2*p2-o2

# n2*p2 == n1*p1+1
# n2 = (n1*p1+1)/p2
# n10 = (n1*19+9)

# b = n1*19-1
# b = n2*41-10
