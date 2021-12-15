import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        yield (line[0], int(line[1:]))

DIR2DIR = {
    'N': 0,
    'E': 1,
    'S': 2,
    'W': 3
}

def solve1(inp):
    dir = 1
    x = 0
    y = 0
    for ins,num in inp:
        if ins=="L" or ins=="R":
            num=num/90
            if ins=='L':
                num*=-1
            dir = (dir + 4 + num) % 4
        else:
            if ins=="F":
                sdir = dir
            else:
                sdir = DIR2DIR[ins]
            if sdir % 2 == 1:
                x += num * (-1 if sdir==3 else 1)
            else:
                y += num * (-1 if sdir==2 else 1)
    print(abs(x)+abs(y))
    return (x,y)

def solve2(inp):
    vx = 10
    vy = 1
    x = 0
    y = 0
    for ins,num in inp:
        if ins=="L" or ins=="R":
            for _ in range(num//90):
                if ins=="L":
                    vx,vy=-vy,vx
                else:
                    vx,vy=vy,-vx
        elif ins=="F":
            x += vx * num
            y += vy * num
        else:
            sdir = DIR2DIR[ins]
            if sdir % 2 == 1:
                vx += num * (-1 if sdir==3 else 1)
            else:
                vy += num * (-1 if sdir==2 else 1)
    print(abs(x)+abs(y))
    return (x,y)
        
solve2(inp())

#39 start
#49 113 wrong (wrong direction, east not north. corrected myself)
#50 381
#53:30 257398 wrong high (missed vx update branch in main)
#54:30 13491 wrong low (missed initial waypoint)
#55:40 14185 wrong low
#59:17 34703 wrong
#06:15 30279 wrong
#09:55 29019 time penalty
#11:15 29019 wrong (5 min penalty) left out dir//90
#14:50 (time penalty left)
#16:20 28591
#35 fucking min
