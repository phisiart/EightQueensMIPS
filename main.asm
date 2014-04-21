.data
    strfinish:
        .asciiz "Finished!\n"
        
.text
.globl main

main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)      # save ra to sp[0]
    
        addi $sp, $sp, -4
        sw $s0, 0($sp)
        
        addi $sp, $sp, -4
        sw $s1, 0($sp)
            
            move $s1, $zero             # use s1 to count, set s1 to 0
            
            add $s0, $zero, $zero       # for s0 = 0..7
            loop0:
            
                li $t0, 1
                sllv $t0, $t0, $s0      # t0 = 1 << s0
                sll $t0, $t0, 24        # t0 = t0 << 24
                or $a0, $s0, $t0        # a0 = s0 | t0
                li $a1, 1               # a1 = 1
                    jal PutAndCheck
                add $s1, $s1, $v0
                
                addi $s0, $s0, 1        # s0 += 1
                slti $t0, $s0, 8        # t0 = (s0 < 8)
                bne $t0, $zero, loop0   # if s0 < 8: goto loop0
        
            li $v0, 1
            move $a0, $s1
            syscall                 # Print count

        lw $s1, 0($sp)
        addi $sp, $sp, 4    
        
        lw $s0, 0($sp)
        addi $sp, $sp, 4
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    li $v0, 4
    la $a0, strfinish
    syscall
    
    jr $ra

# main ends.

PutAndCheck:
# params:
# $a0: the current state,
# $a1: the line of next input,
# $v0: the count of successful arrangements

    move $v0, $zero
    jr $ra
    
# PutAndCheck ends.