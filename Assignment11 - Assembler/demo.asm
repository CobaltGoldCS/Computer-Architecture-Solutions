.data
# Screen address space: 0x1FFF
start_screen_address: 16384
screen_space: 8192
zero: 0
keyboard: 24576
spaceKey: 32


.text
main:
	jal wait_for_space
	lw R2, start_screen_address
	lw R3, zero
	lw R4, screen_space # End Loop Index
	screen_loop:
		beq R3, R4, reset_screen
		sw R2, 0(R2)
		
		addi R2, R2, 1
		addi R3, R3, 1
		
		display
		j screen_loop
	reset_screen:
		jal wait_for_space
		lw R2, start_screen_address
		lw R3, zero
		lw R4, screen_space # End Loop Index
		lw R5, zero
		
		reset_loop:
			beq R3, R4, end_loop
			sw R5, 0(R2)
		
			addi R2, R2, 1
			addi R3, R3, 1
			display
			j reset_loop
		end_loop:
	j main
	
# Pauses screen until space is pressed
# Clobbers R6, R5, R7
wait_for_space:
	lw R6, spaceKey
	inputLoop:
		lw R5, keyboard
		lw R5, 0(R5)
    		bne R5, R6, inputLoop
    	jr R7