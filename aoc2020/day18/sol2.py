import collections, functools, operator

def inp():
    for line in open("input.txt"):
        line = line.strip()
        idx = 0
        res = []
        while idx < len(line):
            ch = line[idx]
            if ch == " ":
                while idx<len(line) and line[idx]==" ":
                    idx+=1
                continue
            if "+*()".find(ch) > -1:
                res.append(ch)
                idx+=1
                continue
            idx2=idx
            while idx2<len(line) and "0123456789".find(line[idx2]) > -1:
                idx2+=1
            res.append(int(line[idx:idx2]))
            idx=idx2
            continue
        yield res

ops = {
    '+': operator.add,
    '-': operator.sub,
    '*': operator.mul,
#    '/': operator.div,
}

class Solver():
    def __init__(self, tokens):
        self.tokens=tokens
        self.idx=0   
    def has_next(self,):
        return self.idx < len(self.tokens)
    def is_num(self,):
        return type(len(self.tokens)) == int
    def num(self):
        if self.tokens[self.idx] == "(":
            self.idx+=1
            num1 = self.expr()
        else:
            num1 = self.tokens[self.idx]
        self.idx+=1 # )
        return num1        
    def bl(self):
        num1=self.num()
        while self.idx < len(self.tokens) and self.tokens[self.idx] != ')' and self.tokens[self.idx] != '*':
            op = self.tokens[self.idx]
            self.idx+=1
            #print([self.idx, op])
            num2=self.num()
            num1=ops[op](num1, num2)
        return num1
    def expr(self):
        num1=self.bl()
        while self.idx < len(self.tokens) and self.tokens[self.idx] != ')' and self.tokens[self.idx] != '+':
            op = self.tokens[self.idx]
            self.idx+=1
            #print([self.idx, op])
            num2=self.bl()
            num1=ops[op](num1, num2)
        return num1
    def solve(self):
        self.idx = 0
        return self.expr()

r = 0
for expr in inp():
    r += Solver(expr).solve()

print(r)

# @17:42 #515 =16332191652452
# @23:36 #380 =351175492232654