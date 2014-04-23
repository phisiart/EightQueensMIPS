## Eight Queens on MIPS
> Zhixun TAN <br />
> EE 25 <br />
> 2012011120

The basic idea is putting the queens one row after another. First, we know that any two queens can't be in the same row, which indicates that for any row (0 to 7), there can only be exactly one queen.

For each row, there are 8 positions (namely columns) where we can put the queen. So we may use a number between 0 to 7 to denote the position of the queen in each row. There are 8 rows in all, meaning that we need 8 numbers. Each number requires 3 bits, so 8 numbers require 24 bits in all, which can be stored in one single `word`.

How do we check that not any two queens are in the same column? This requires us to track the previous moves before make the new move. In other words, suppose we are about to put a queen in row 3, col 4, we must first make sure that there are no previous queens in col 4. Thus, we use an 8-bit bitset to denote which columns have been 'used'.

For example, before any queen is put, the bitset is `00000000`. We put a queen in row 0, col 1, then the bitset becomes `01000000`. Then we put a queen in row 1, col 3, the bitset becomes `01010000`. Then we put a queen in row 2, col 1, but wait! -- from the bitset we know that col 1 has been occupied, so we can't do that.

The situation is similar when it comes to diagonals. There are 14 left diagonals:

	 7  8  9 10 11 12 13 14
	 6  7  8  9 10 11 12 13
	 5  6  7  8  9 10 11 12
	 4  5  6  7  8  9 10 11
	 3  4  5  6  7  8  9 10
	 2  3  4  5  6  7  8  9
	 1  2  3  4  5  6  7  8
	 0  1  2  3  4  5  6  7

There are also 14 right diagonals.

### Python version of Eight Queens:
Here we give the python version of the algorithm above.

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
	        print oct(curr)
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
	    
	print count


### RESULT
<center>
![](http://www.phisiart.com/pics/spim.png)
</center>