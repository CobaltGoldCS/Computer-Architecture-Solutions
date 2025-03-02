.data
space: .asciiz " "
newline: .asciiz "\n"
prompt: .asciiz "Please enter a fibonacci number: "

.align 2
array: .space 128

.text
.globl main

# a0 - Fibbonacci Number n
# v0 - The final fibbonacci number
fib:
	beq $a0, 0, zero_case
	beq $a0, 1, one_case
	move $t0, $a0
	
	subi $sp, $sp, 12 # Reserve stack space
	sw $t0 0($sp) # store n
	sw $ra 4($sp) # store ra
	
	subi $a0, $t0, 1 # arg = n - 1
	jal fib
	
	sw $v0 8($sp) # Store result of fib(n - 1)
	
	lw $t0, 0($sp) # Load n
	subi $a0, $t0, 2 # arg = n - 2
	jal fib
	
	lw $t1, 8($sp) # load fib(n - 1)
	lw $ra, 4($sp) # load ra
	addi $sp, $sp, 12 # remove stack space
	
	add $v0, $t1, $v0 # Result = fib(n - 1) + fib(n - 2)
	
	
	jr $ra
	
	zero_case:
		li $v0, 0
		jr $ra
	
	one_case:
		li $v0, 1
		jr $ra


# a0 - The starting address of the array
# a1 - The length of the array
print_array:
	li $t0, 1
	move $t1, $a0
	addi $t2, $a1, 1
	
	print_loop:
		beq $t0, $t2, end_print_loop
		
		li $v0, 1
		lw $a0, ($t1)
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4 # Move to the next item in the array
		j print_loop
	
	end_print_loop:
	
		la $a0, newline
		syscall
		
		jr $ra
	
	
	

main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 # The number of fibbonacci numbers to print
	
	li $s2, 0
	la $s1, array # Current Array Index
	creation_loop:
		beq $s2, $s0, end_creation
		
		move $a0, $s2 # arg = i
		jal fib
		sw $v0, ($s1) # store array[i] = fib(i)
		
		la $a0, array
		addi $a1, $s2, 1
		jal print_array
		
		addi $s2, $s2, 1 # i++
		addi $s1, $s1, 4 # Move to the next item in the array
		j creation_loop
	end_creation:
	
	
	
	
