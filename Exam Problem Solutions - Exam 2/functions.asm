.data

.text

.globl main


# Add two to a given number
# a0 - The number to add two to
# v0 - a0 + 2
addTwo:
	move $t0, $a0
	addi $v0, $t0, 2
	jr $ra
	
# Add three to a given number
# a0 - The number to add three to
# v0 - a0 + 2
addThree:
	move $t0, $a0
	addi $v0, $t0, 3
	jr $ra	

# Returns addTwo(x) + addThree(y)
# a0 - x
# a1 - y
# v0 - addTwo(a0) + addThree(a1)
doubleSum:	
	# Set up stack
	subi $sp, $sp, 12
	sw $a1, 0($sp)
	sw $ra, 4($sp)
	
	jal addTwo
	sw $v0, 8($sp) # store result of calculation in ram[sp + 8] 
	
	lw $a0, 0($sp)
	jal addThree
	
	lw $t0, 8($sp) # t2 = addTwo(x)
	lw $ra, 4($sp)
	addi $sp, $sp, 12
	
	add $v0, $t0, $v0 #v0 = addTwo(x) + addThree(y) 
	
	jr $ra



main:

	li $a0, 5
	li $a1, 10
	jal doubleSum # doubleSum(5,10)
	
	move $s0, $v0 # 20
	
	li $a0, 2
	li $a1, 7
	jal doubleSum # doubleSum(2,7)
	
	move $s1, $v0 # 14

	