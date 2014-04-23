# -*- coding: utf-8 -*-

num = 8
curr = 0
vert = 0
ldiag = 0
rdiag = 0
row = 0
pos = 0
count = 0

while (True):
    
    if pos == num and row == 0: # BREAK
        break
    
    if row == num: # success
        print "ans", count, ":", str(oct(curr))[1:]
        pos = curr & 7
        curr = curr >> 3

        row -= 1
        vert = vert & (~(1 << pos))
        ldiag = ldiag & (~(1 << (7 - row + pos)))
        rdiag = rdiag & (~(1 << (row + pos)))
        pos += 1
        count += 1
        continue

    if pos == num and row != 0: # POP
        pos = curr & 7
        curr = curr >> 3
        
        row -= 1
        vert = vert & (~(1 << pos))
        ldiag = ldiag & (~(1 << (7 - row + pos)))
        rdiag = rdiag & (~(1 << (row + pos)))
        pos += 1
        continue

    # PUSH
    # Check the correctness of this move.
    t_vert = 1 << pos
    t_ldiag = 1 << (7 - row + pos)
    t_rdiag = 1 << (row + pos)
    
    fail = vert & t_vert
    fail = fail | (ldiag & t_ldiag)
    fail = fail | (rdiag & t_rdiag)
    
    if fail == 0:
        curr = curr << 3
        curr = curr | pos
        
        vert = vert | t_vert
        ldiag = ldiag | t_ldiag
        rdiag = rdiag | t_rdiag
        pos = 0
        row += 1
        
    else:
        pos += 1
    
print "There are", count, "answers"