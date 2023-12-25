from sympy import symbols, Eq, solve

px, py, pz, vx, vy, vz = symbols('px py pz vx vy vz', integer=True)
vars = [px, py, pz, vx, vy, vz]
eqs = []
for idx, row in enumerate(open("input")):
	if idx>10:
		break
	p, v = row.split(" @ ")
	p = list(map(int, p.split(", ")))
	v = list(map(int, v.split(", ")))
	t = symbols(f't{idx}', integer=True, positive=True)
	vars.append(t)
	eqs.append(Eq(px + t * vx, p[0] + t * v[0]))
	eqs.append(Eq(py + t * vy, p[1] + t * v[1]))
	eqs.append(Eq(pz + t * vz, p[2] + t * v[2]))

print(vars)
print(eqs)

solution = solve(eqs, vars, cubics=False)

p = solution[0][:3]
v = solution[0][3:6]

print(solution)
print(p)
print(v)
print(sum(p))

# 1025127405449117
