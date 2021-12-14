# requirements:
#	primefactorized format can have only numbers on first power
#		=> each possible solution is a prod subset prime
#	60%
#	possible solutions should have 2 in their prime factorization
#	10%

# >>> sum(solve(10**8))
# 501311966516L
# time ~ 168.33 min
# time = 53.55 sec

import base
from time import time

def gen_stepper(level):
	def reversed_steps(steps):
		for dir, idx in reversed(steps):
			yield 1-dir, idx
	res = []
	base = [(0, 0)]
	for clevel in range(level):
		base = base[:-1] + [(0, clevel)] + list(reversed_steps(base[:-1])) + [(1, clevel)]
		res.append(base[0:len(base)/2-1])
	return res

def solve(vlimit):
	a=time()
	limit=vlimit/2
	primes = base.primesbelow(vlimit)
	sprimes = set(primes)
	num_primes = len(primes)
	steppers = gen_stepper(12)
	def is_prime(num):
		return num in sprimes
	def is_solution_delta(factors):
		a = 1
		b = reduce(lambda a,b:a*b, factors)
		if not is_prime(a+b):
			return False
		for dir, idx in steppers[len(factors)-1]:
			if dir:
				a /= factors[idx]
				b *= factors[idx]
			else:
				a *= factors[idx]
				b /= factors[idx]
			if not is_prime(a+b):
				return False
		return True
	def is_solution_slow(factors):
		num_factors = len(factors)
		def div_pair_sum(num_a, num_b, idx):
			if idx == num_factors:
				yield is_prime(num_a + num_b)
			else:
				yield all([all(div_pair_sum(num_a * factors[idx], num_b, idx+1)), all(div_pair_sum(num_a, num_b * factors[idx], idx+1))])
		return all(div_pair_sum(1,1,0))
	def is_solution_old(factors):
		num_factors = len(factors)
		def div_pair_sum(num_a, num_b, idx):
			if idx == num_factors:
				yield num_a + num_b
			else:
				for res in div_pair_sum(num_a * factors[idx], num_b, idx+1):
					yield res
				for res in div_pair_sum(num_a, num_b * factors[idx], idx+1):
					yield res
		return all(is_prime(num) for num in div_pair_sum(1,1,0))
	is_solution = is_solution_delta
	def unifactory(curr, items, idx):
		tmp = curr
		while idx<num_primes:
			curr = tmp * primes[idx]
			if (curr > vlimit): break
			items.append(primes[idx])
			if is_solution(items): yield curr
			idx += 1
			for res in unifactory(curr, items, idx): yield res
			items.pop()
	def flatfactory(curr, items, idx):
		sp = 0
		state = [1]*20
		while True:
			if idx>=num_primes or curr * primes[idx] > vlimit:
				if sp>0:
					sp-=1
					curr, idx = state[sp]
					items.pop()
					continue
				else:
					break
			items.append(primes[idx])
			if is_solution(items): yield curr * primes[idx]
			state[sp] = (curr, idx+1)
			sp+=1
			curr *= primes[idx]
			idx += 1
	solution_factory = unifactory
	
	res = sum(solution_factory(2,[2],1)) + 1 + 2
	print time()-a, res, vlimit
	return res

solve(100000000)
