.data

a: .word 1
b: .word 2
c: .word 3

result: .space 4

.text
la $t1, a

lw $t2, 0($t1)
lw $t3, 4($t1)
lw $t4, 8($t1)

# t2 should have the sum after these additions
add $t2, $t2, $t3
add $t2, $t2, $t4

# Store in result label
sw $t2, 12($t1)

#print integer
li $v0, 1

add $a0, $zero, $t2

syscall

# Graceful Shutdown
li $v0, 10
syscall

.globl main

main:
