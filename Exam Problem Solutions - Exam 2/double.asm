.data

array: .word -3, -2, -1, 0, 1, 2, 3

arrayLen: .word 7

.text

.globl main


main:

	li $t0, 1
	lw $t2, arrayLen
	
	# Array index
	la $t1, array
	
	li $v0, 1
	
	loop:
		bgt $t0, $t2, endLoop
		
		lw $t3, 0($t1) # Value of the array at i
		
		mul $t3, $t3, 2 
		
		sw $t3, 0($t1)
		
		move $a0, $t3
		
		syscall
		
		
		
		
		# Increment and loop
		addi $t0, $t0, 1
		addi $t1, $t1, 4
		j loop
	
	endLoop:

