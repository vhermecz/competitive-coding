import base
from time import time

primes = base.primesbelow(10**8)

def extended_gcd(a, b):
	x, lastx = 0, 1
	y, lasty = 1, 0
	while b != 0:
		quotient = a / b
		a, b = b, a % b
		x, lastx = lastx - quotient*x, x
		y, lasty = lasty - quotient*y, y
	return lastx, lasty

def multiplicative_inverse(p, n):
	return extended_gcd(p, n)[1]

def fact(n, p):
	i = 1
	for n in range(1, n+1):
		i = (i * n) % p
	return i

def S(p):
	v = fact(p-5, p)
	r = v
	for n in range(p-4, p):
		v = (v * n) % p
		r += v
	r %= p
	return r

def Sfast(p):
	#(p-1)! = -1 (mod p) # Wilson's theorem
	v = p - 1
	r = v
	for n in range(p-1,p-5,-1):
		v = v * multiplicative_inverse(p, n)
		r += v
	r %= p
	return r

def solve(limit):
	r = 0
	for p in primes:
		if p<5:
			continue
		if p>=limit:
			break
		r += Sfast(p)
	return r

t1 = time()
print solve(10**8)
t2 = time()
print t2-t1

# solution = 139602943319822
# time = 92.6069998741