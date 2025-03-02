.data
prompt: .asciiz "Please enter a number: "
newLine: .ascii "\n\0"
.text
.globl main

main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0 # Get number of fibbonacci numbers
	
	li $t1, 0
	
	
	li $t2, 0
	li $t3, 1
	
	begin_loop:
		beq $t0, $t1, end_loop
		
		# Print fibbonacci number
		li $v0, 1 
		move $a0, $t2
		syscall
		
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		
		move $t4, $t3 # Create temp
		
		add $t3, $t3, $t2 # Add fibbonacci numbers together
		
		move $t2, $t4 # Move previous fibbonacci number to the smaller addend
		
		addi $t1, $t1, 1
		j begin_loop
	
	end_loop:
		li $v0, 10
		syscall
