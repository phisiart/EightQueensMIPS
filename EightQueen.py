# -*- coding: utf-8 -*-

num = 3
cur = []
curr = [0]
curbit = 0
line = 0
pos = 0
count = 0

while (True):
    if pos == num and line == 0:
        break
    if line == num: # success
        print bin(curbit), cur
        count += 1
        line -= 1
        pos = cur[line] # last pos
        curbit = curbit & (~(1 << pos))
        pos += 1
        continue
    if pos == num and line != 0:
        line -= 1
        pos = cur[line]
        curbit = curbit & (~(1 << pos))
        pos += 1
        continue
    
    cur[line] = pos
    curbit = curbit | (1 << pos)
    pos = 0
    line += 1
    
print count
print 1 << 2