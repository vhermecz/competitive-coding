import itertools
from time import time
import collections
import math
from math import *

def binomial(n,k): return factorial(n)/factorial(k)/factorial(n-k)

def primesbelow(N):
    # http://stackoverflow.com/questions/2068372/fastest-way-to-list-all-primes-below-n-in-python/3035188#3035188
    #""" Input N>=6, Returns a list of primes, 2 <= p < N """
    correction = N % 6 > 1
    N = {0:N, 1:N-1, 2:N+4, 3:N+3, 4:N+2, 5:N+1}[N%6]
    sieve = [True] * (N // 3)
    sieve[0] = False
    for i in range(int(N ** .5) // 3 + 1):
        if sieve[i]:
            k = (3 * i + 1) | 1
            sieve[k*k // 3::2*k] = [False] * ((N//6 - (k*k)//6 - 1)//k + 1)
            sieve[(k*k + 4*k - 2*k*(i%2)) // 3::2*k] = [False] * ((N // 6 - (k*k + 4*k - 2*k*(i%2))//6 - 1) // k + 1)
    return [2, 3] + [(3 * i + 1) | 1 for i in range(1, N//3 - correction) if sieve[i]]

def isprime(n):
	if n<=primes[-1]: return n in sprimes
	limit = int(n**0.5)+1
	for p in primes:
		if p>limit: return True
		if n%p==0: return False

def divisors(n):
	primdivs = []
	for i in primes:
		if n==1: break
		if n%1==0:
			part = [1]
			v = i
			while n%i==0:
				part.append(v)
				n/=i
				v*=i
			primdivs.append(part)
		i+=1
	divs = []
	for comb in itertools.product(*primdivs):
		divs.append(reduce(lambda x,y:x*y, comb))
	return divs

def squareroot(apositiveint):
	root = int(apositiveint**0.5)
	return (root**2==apositiveint, root)

primes = primesbelow(10**6)
sprimes = set(primes)

def factorize(n):
	if n<2: return []
	factors = []
	for p in primes:
		if n==1:break
		if n%p==0:
			c=1
			n/=p
			while n%p==0:
				c+=1
				n/=p
			factors.append((p, c))
	return factors