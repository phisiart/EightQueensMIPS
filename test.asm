.data
    strfinish:
        .asciiz "Finished!\n"
    stra0:
        .asciiz "a0 = "
    stra1:
        .asciiz "a1 = "
    strline:
        .asciiz "\n"
        
.text
.globl main
.globl loop1
main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)      # save ra to sp[0]
    
        addi $sp, $sp, -4
        sw $s0, 0($sp)
        addi $sp, $sp, -4
        sw $s1, 0($sp)
        addi $sp, $sp, -4
        sw $a0, 0($sp)
        addi $sp, $sp, -4
        sw $a1, 0($sp)
        
            move $s1, $zero             # use s1 to count, set s1 to 0
            
            add $s0, $zero, $zero       # for s0 = 0..7
            loop0:
                # print "\n"
                    addi $sp, $sp, -4
                    sw $a0, 0($sp)
                        li $v0, 4
                        la $a0, strline
                        #syscall
                    lw $a0, 0($sp)
                    addi $sp, $sp, 4
                
                li $t0, 1
                sllv $t0, $t0, $s0      # t0 = 1 << s0
                sll $t0, $t0, 24        # t0 = t0 << 24
                or $a0, $s0, $t0        # a0 = s0 | t0
                li $a1, 1               # a1 = 1
                addi $sp, $sp, -4
                sw $ra, 0($sp)
                    jal PutAndCheck
                lw $ra, 0($sp)
                addi $sp, $sp, 4
                add $s1, $s1, $v0
                
                addi $s0, $s0, 1        # s0 += 1
                slti $t0, $s0, 8        # t0 = (s0 < 8)
                bne $t0, $zero, loop0   # if s0 < 8: goto loop0
        
            addi $sp, $sp, -4
            sw $a0, 0($sp)
                li $v0, 1
                move $a0, $s1
                syscall                 # Print count
            lw $a0, 0($sp)
            addi $sp, $sp, 4
            
        lw $a1, 0($sp)
        addi $sp, $sp, 4
        lw $a0, 0($sp)
        addi $sp, $sp, 4
        lw $s1, 0($sp)
        addi $sp, $sp, 4
        lw $s0, 0($sp)
        addi $sp, $sp, 4
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    li $v0, 4
    la $a0, strfinish
    #syscall
    
    jr $ra

# main ends.

PutAndCheck:
# params:
# $a0: the current state,
# $a1: the line of next input,
# $v0: the count of successful arrangements
    
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    addi $sp, $sp, -4
    sw $s1, 0($sp)
    addi $sp, $sp, -4
    sw $a0, 0($sp)
    addi $sp, $sp, -4
    sw $a1, 0($sp)
    
        li $s1, 0       # use s1 to count
        li $s0, 0       # for s0 = 0..7
        loop1:
            
            # print s0: begin.
                addi $sp, $sp, -4
                sw $a0, 0($sp)
                    move $a0, $s0
                    li $v0, 1
                    #syscall
                lw $a0, 0($sp)
                addi $sp, $sp, 4
            # print s0: end.
            
            # now what's left here is the success.
            
            addi $sp, $sp, -4
            sw $a0, 0($sp)
            addi $sp, $sp, -4
            sw $a1, 0($sp)
            
                addi $a1, $a1, 1
                
                # if a1 == 8: don't call PutAndCheck
                slti $t0, $a1, 6            # t0 = (a1 < 8)
                beq $t0, $zero, non_recursive       # if a1 >= 8: goto loop1
                
                recursive:
                    addi $sp, $sp, -4
                    sw $ra, 0($sp)
                        jal PutAndCheck
                    lw $ra, 0($sp)
                    addi $sp, $sp, 4
                    add $s1, $s1, $v0
                    j ok
                    
                non_recursive:
                    addi $s1, $s1, 1
                    
                ok:
                
            lw $a1, 0($sp)
            addi $sp, $sp, 4
            lw $a0, 0($sp)
            addi $sp, $sp, 4
            
            fail:
            addi $s0, $s0, 1            # s0 += 1
            slti $t0, $s0, 8            # t0 = (s0 < 8)
            bne $t0, $zero, loop1       # if s0 < 8: goto loop1
            
        move $v0, $s1
    
    lw $a1, 0($sp)
    addi $sp, $sp, 4
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    lw $s1, 0($sp)
    addi $sp, $sp, 4
    lw $s0, 0($sp)
    addi $sp, $sp, 4
        
    jr $ra
    
# PutAndCheck ends.