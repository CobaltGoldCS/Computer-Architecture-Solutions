.data
	myArray: .word 8, 3, 6, 2, 1, 9, 7, 4, 5, 10
	myArrayLen: .word 10
	
	beforeText: .asciiz "Before sorting: "
	afterText: .asciiz "After sorting: "
	
	space: .asciiz " "
	newLine: .asciiz "\n"
	
.text
.globl main
main:

	li $v0, 4
	la $a0, beforeText
	syscall
	
	la $t0, myArray # t0 holds myArray
	lw $t1, myArrayLen # Upper limit is in $t1
	li $t2, 0 
	
	beforeLoop:
		beq $t1, $t2, endBeforeLoop
		
		# Print Array
		li $v0, 1 
		lw $a0, ($t0)
		syscall
		
		li $v0, 4
		la $a0, space
		syscall # Print space
		
		# Increment
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j beforeLoop
	
	endBeforeLoop:
		la $a0, newLine
		syscall
		
	
	# Set up iteration loop
	subi $t1, $t1, 1 # We want to go n-1 loops so that we don't reach out of bounds
	li $t6, 0 # Index of iterationLoop
	iterationLoop:
		beq $t1, $t6, endIterationLoop
		
		# Set up bubble sorting swap loop
		li $t2, 0 
		la $t0, myArray # t0 holds myArray
		bubbleLoop:
			beq $t1, $t2, endBubbleLoop
		
			# Get the next two elements
			lw $t3, 0($t0) # element 1
			lw $t4, 4($t0) # element 2
		
			bgt $t4, $t3, incBubbleLoop # If they are in the correct order, skip this iteration
		
			sw $t3, 4($t0) # Swap element one and two
			sw $t4, 0($t0)
			
			li $t7, 1 # If a swap did occur, set t7 to 1
		
			incBubbleLoop:
				addi $t2, $t2, 1
				addi $t0, $t0, 4
				j bubbleLoop
		endBubbleLoop:
			# Increment for IterationLoop
			addi $t6, $t6, 1
			
			# End early if $t7 detected no swaps
			beqz $t7, endIterationLoop
			li $t7, 0
			
			j iterationLoop
	
	endIterationLoop:
	
		li $v0, 4
		la $a0, afterText	
		syscall
	
		# Set up the after loop
		li $t2, 0 
		la $t0, myArray 
		addi $t1, $t1, 1 # We previously had this set to iterate n - 1 times for swapping purposes
	afterLoop:
		beq $t1, $t2, endAfterLoop
		
		
		# Print Array
		li $v0, 1 
		lw $a0, ($t0)
		syscall
		
		li $v0, 4
		la $a0, space
		syscall # print space
		
		# Increment
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j afterLoop
	
	endAfterLoop:
		li $v0, 10 # close gracefully
		syscall
	
	 
