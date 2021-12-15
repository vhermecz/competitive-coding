def parseline(line):
    range, letter, pwd = line.split(" ")
    vmin, vmax = map(int, range.split("-"))
    letter = letter[0]
    return vmin, vmax, letter, pwd

def checkline1(line):
    vmin, vmax, letter, pwd = parseline(line)
    return vmin <= pwd.count(letter) <= vmax

def checkline2(line):
    vmin, vmax, letter, pwd = parseline(line)
    oneOfThem = (pwd[vmin-1] == letter)!=(pwd[vmax-1] == letter)
    return oneOfThem

print(sum([checkline1(line.strip()) for line in open("input")]))

print(sum([checkline2(line.strip()) for line in open("input")]))
