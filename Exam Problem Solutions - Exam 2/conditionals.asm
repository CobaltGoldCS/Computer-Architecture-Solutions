.data

	prompt: .asciiz "Enter in a number: "
	msg1: .asciiz "Greater than 5"
	msg2: .asciiz "Less than -5"
	

.text
.globl main

main: 
	# Print the prompt
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Store input in $t0
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 4
	
	li $t2, -5
	slt $t1, $t0, $t2
	beq $t1, 1, lessThan
	
	li $t2, 5
	slt $t1, $t2, $t0
	beq $t1, 1, greaterThan
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	j endCase
	
	
lessThan:
	# Print the less than message
	la $a0, msg2
	syscall
	
	j endCase
	
greaterThan:
	# Print the greater than message
	la $a0, msg1
	syscall
	
	j endCase

	
	
endCase: