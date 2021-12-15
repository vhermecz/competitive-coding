a = 0
b = [666,0,0]
c = 2
a = b[a] = c
# 1 [2, 0, 0]
#data[cur] = nxt
#cur = nxt

# 2 [666,0,2]
cur = data[cur] = nxt
print(cur)
print(nxt)
print(data)
