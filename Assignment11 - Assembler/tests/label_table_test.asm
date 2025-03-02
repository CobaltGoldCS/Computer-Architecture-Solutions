main:
# This is the start of my countdown program!
addi R1, R0, 0 # i = 0
addi R2, R0, 10 # stop at 10

loop:
 beq R1, R2, end_loop # Check to see if we've reached 10

addi R1, R1, 1 #i += 1

j loop



end_loop:
end_program: