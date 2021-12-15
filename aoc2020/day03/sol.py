import operator
import functools

maze = [line.strip() for line in open("input")]

width = len(maze[0])
height = len(maze)

def is_tree(x,y):
    return maze[y][x] == '#'

def count_slope(dx, dy):
    cnt = x = y = 0
    while y < height:
        if is_tree(x%width,y):
            cnt += 1
        x += dx
        y += dy
    return cnt

print(count_slope(3,1))
print([count_slope(x,y) for x,y in [(1,1),(3,1),(5,1),(7,1),(1,2)]], 1)
print(functools.reduce(operator.mul, [count_slope(x,y) for x,y in [(1,1),(3,1),(5,1),(7,1),(1,2)]], 1))
