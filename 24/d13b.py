from z3 import *
import re, sys

t = 0
for g in open(sys.argv[1]).read().split("\n\n"):
    l = [int(i) for i in re.findall(r"\d+", g)]
    A, B = Ints("A B")
    s = Solver()
    s.add(A * l[0] + B * l[2] == l[4] + 10000000000000)
    s.add(A * l[1] + B * l[3] == l[5] + 10000000000000)
    r = s.check()
    if r == sat:
        m = s.model()
        t += m[A].as_long() * 3 + m[B].as_long()
print(t)
