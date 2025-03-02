.data
a: .word 1
b: .word 5
c: .word 4
d: .word 2

sum: .space 4
average: .space 4

.text
la $t0, a
lw $t1, 0($t0)
lw $t2, 4($t0)
lw $t3, 8($t0)
lw $t4, 12($t0)

add $t5, $t1, $t2
add $t6, $t3, $t4
add $t6, $t5, $t6

sw $t6, 16($t0) # Store sum

li $t2, 4
div $t1, $t6, $t2

sw $t1, 20($t0)

li $v0, 1

move $a0, $t1
syscall

.globl main

main:
