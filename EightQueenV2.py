# -*- coding: utf-8 -*-

num = 8
cur = []
curbit = 0
line = 0
pos = 0
count = 0

while (True):
    #print "cur = ", cur, "; pos = ", pos, "; line = ", line
    if pos == num and line == 0:
        break    
    
    if line == num: # success
        print cur
        pos = cur.pop() # last pos
        curbit = curbit & (~(1 << pos))
        pos += 1
        line -= 1
        count += 1
        continue

    if pos == num and line != 0:
        pos = cur.pop() # last pos
        curbit = curbit & (~(1 << pos))
        pos += 1
        line -= 1
        continue

    # Check the correctness of this move.
    fail = curbit & (1 << pos)
    if line != 0:
        last_pos = cur[-1]
        fail = fail or last_pos - pos == 1 or last_pos - pos == -1
    
    if fail == False:
        cur.append(pos)
        curbit = curbit | (1 << pos)
        pos = 0
        line += 1
        
    else:
        pos += 1
    
print count