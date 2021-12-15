#51:30
#57:30 first sol (6m)
#02:30 (11m)
def input():
    for line in open("input"):
        line = line.strip()
        cmd, num = line.split(" ")
        yield cmd, int(num)

code = list(input())

def test(code):
    acc = 0
    addr = 0
    flag = [0]*len(code)
    while True:
        if addr == len(code) or flag[addr]==1:
            break
        flag[addr]=1
        cmd, num = code[addr]
        if cmd=="acc":
            acc += num
            addr += 1
        elif cmd=="nop":
            addr += 1
        elif cmd=="jmp":
            addr += num
    return acc, addr

def swap(cmd):
    return "jmp" if cmd == "nop" else "nop"

for i in range(len(code)):
    orig = False
    if code[i][0] != 'acc':
        orig = code[i][0]
        code[i] = (swap(orig), code[i][1])
    acc, addr = test(code)
    if addr == len(code):
        print(acc)
        break
    if orig:
        code[i] = (orig, code[i][1])

print(test(code))
