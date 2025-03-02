.data

astring: .asciiz "Enter a: "
bstring: .asciiz "Enter b: "
cstring: .asciiz "Enter c: "

minusstring: .asciiz " - "
plusstring: .asciiz " + "
equalstring: .asciiz " = "

.text
.globl main

main:

	# collect first number

	li $v0, 4
	la $a0, astring
	syscall

	li $v0, 5
	syscall
	move $t1, $v0

	# collect second number

	li $v0, 4
	la $a0, bstring
	syscall

	li $v0, 5
	syscall
	move $t2, $v0

	# collect third number

	li $v0, 4
	la $a0, cstring
	syscall

	li $v0, 5
	syscall
	move $t3, $v0

	# Calculate a - b + c

	#b + C
	sub $t4, $t1, $t2
	add $t4, $t4, $t3


	# Print out the long string

	# Print a
	li $v0, 1
	move $a0, $t1
	syscall

	# Print minus
	li $v0, 4
	la $a0, minusstring
	syscall

	# Print b
	li $v0, 1
	move $a0, $t2
	syscall


	# Print plus
	li $v0, 4
	la $a0, plusstring
	syscall

	# Print c
	li $v0, 1
	move $a0, $t3
	syscall

	# Print equal
	li $v0, 4
	la $a0, equalstring
	syscall

	# Print result
	li $v0, 1
	move $a0, $t4
	syscall


	# Graceful Shutdown
	li $v0, 10
	syscall