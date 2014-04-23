.data

.text
.globl main

main:
    # variables:
    # s0 : curr = 0
    # s1 : count = 0
    # s2 : row = 0
    # s3 : pos = 0
    # s4 : vert = 0
    # s5 : ldiag = 0
    # s6 : rdiag = 0

    li $s0, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    
    LOOP:
        # if pos == 8 and row == 0: BREAK
            addi $t0, $s3, -8       # t0 = s3 - 8
            or $t0, $t0, $s2        # t0 = t0 or s2
            beq $t0, $zero, BREAK   # if not t0 goto BREAK
        
        # if row == 8: SUCCESS
            addi $t0, $s2, -8
            beq $t0, $zero, SUCCESS # if t0 == 0 goto SUCCESS
        
        # if pos == 8 and row != 0: POP
            addi $t0, $s3, -8       # t0 = s2 - 8
            bne $t0, $zero, PUSH
            bne $s2, $zero, POP
            j PUSH
        
        SUCCESS:
            andi $s3, $s0, 7        # pos = curr & 7
            srl $s0, $s0, 3         # curr = curr >> 3
            
            # vert = vert & (~(1 << pos))
                li $t0, 1
                sllv $t0, $t0, $s3
                li $t1, -1
                xor $t0, $t0, $t1
                and $s4, $s4, $t0
            
            addi $s2, $s2, -1       # row -= 1
            
            # ldiag = ldiag & (~(1 << (7 - row + pos)))
                li $t0, 1
                li $t1, 7
                sub $t1, $t1, $s2
                add $t1, $t1, $s3
                sllv $t0, $t0, $t1
                li $t1, -1
                xor $t0, $t0, $t1
                and $s5, $s5, $t0
            
            # rdiag = rdiag & (~(1 << (row + pos)))
                li $t0, 1
                add $t1, $s2, $s3
                sllv $t0, $t0, $t1
                li $t1, -1
                xor $t0, $t0, $t1
                and $s6, $s6, $t0
            
            addi $s3, $s3, 1        # pos += 1
            addi $s1, $s1, 1        # count += 1

            j LOOP                  # continue
            
        POP:
            andi $s3, $s0, 7        # pos = curr & 7
            srl $s0, $s0, 3         # curr = curr >> 3
            
            # vert = vert & (~(1 << pos))
                li $t0, 1
                sllv $t0, $t0, $s3
                li $t1, -1
                xor $t0, $t0, $t1
                and $s4, $s4, $t0
            
            addi $s2, $s2, -1       # row -= 1
            
            # ldiag = ldiag & (~(1 << (7 - row + pos)))
                li $t0, 1
                li $t1, 7
                sub $t1, $t1, $s2
                add $t1, $t1, $s3
                sllv $t0, $t0, $t1
                li $t1, -1
                xor $t0, $t0, $t1
                and $s5, $s5, $t0
            
            # rdiag = rdiag & (~(1 << (row + pos)))
                li $t0, 1
                add $t1, $s2, $s3
                sllv $t0, $t0, $t1
                li $t1, -1
                xor $t0, $t0, $t1
                and $s6, $s6, $t0
            
            addi $s3, $s3, 1        # pos += 1
            
            j LOOP
            
        PUSH:
            li $t0, 1
            sllv $t6, $t0, $s3      # t6 = t_vert = 1 << pos
            
            li $t0, 1
            li $t1, 7
            sub $t1, $t1, $s2
            add $t1, $t1, $s3
            sllv $t5, $t0, $t1      # t5 = t_ldiag = 1 << (7 - row + pos)
            
            li $t0, 1
            add $t1, $s2, $s3
            sllv $t4, $t0, $t1      # t4 = t_rdiag = 1 << (row + pos)
            
            and $t7, $s4, $t6       # t7 = fail = vert & t0

            and $t0, $s5, $t5       # t0 = ldiag & t5
            or $t7, $t7, $t0        # fail = fail | t0

            and $t0, $s6, $t4       # t0 = rdiag & t4
            or $t7, $t7, $t0        # fail = fail | t0
            
            # if fail: FAIL
            bne $t7, $zero, FAIL
                sll $s0, $s0, 3     # curr = curr << 3
                or $s0, $s0, $s3    # curr = curr | pos
                or $s4, $s4, $t6    # vert = vert | t_vert
                or $s5, $s5, $t5    # ldiag = ldiag | t_ldiag
                or $s6, $s6, $t4    # rdiag = rdiag | t_rdiag
                li $s3, 0           # pos = 0
                addi $s2, $s2, 1    # row += 1
                j LOOP
            FAIL:
                addi $s3, $s3, 1    # pos += 1
                j LOOP
    
    BREAK:
    li $v0, 1
    move $a0, $s1
    syscall
    
    jr $ra
