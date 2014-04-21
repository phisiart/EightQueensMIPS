.data
    strfinish:
        .asciiz "Finished!\n"
        
.text
.globl main

main:
    addi $sp, $sp, -4
    sw $ra, 0($sp)      # save ra
    
        addi $sp, $sp, -4
        sw $s0, 0($sp)
        
            add $s0, $zero, $zero       # for s0 = 0..7
            loop0:
                # do sth.
                li $v0, 1
                move $a0, $s0
                syscall
                
                addi $s0, $s0, 1        # s0 += 1
                slti $t0, $s0, 8        # t0 = (s0 < 8)
                bne $t0, $zero, loop0   # if s0 < 8: goto loop0
            
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

    jr $ra
    
# PutAndCheck ends.