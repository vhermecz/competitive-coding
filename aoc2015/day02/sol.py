res=0
r2=0
for line in open("input.txt"):
    a,b,c = sorted(map(int, line.strip().split("x")))
    res +=2*(a*b+a*c+b*c)+a*b
    r2 += 2*a+2*b+a*b*c

print(res)
print(r2)