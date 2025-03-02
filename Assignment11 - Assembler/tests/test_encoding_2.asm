main:
    lw      R0, 0(R1)        # Load word from memory address of R1 into R0
    lw      R1, 4(R2)         # Load word from memory address of R2 + 4 into R1

    add     R2, R0, R1      # Add R0 and R1, store result in R2
    sw      R2, -4(R3)      # Store word in R2 to memory address of R3 - 4

    sub     R3, R2, R0      # Subtract R0 from R2, store result in R3

    and     R4, R2, R3      # Logical AND of R2 and R3, store result in R4
    or      R5, R2, R3      # Logical OR of R2 and R3, store result in R5

    slt     R6, R4, R5      # Set R6 to 1 if R4 < R5, else 0

    addi    R7, R6, 5       # Add immediate value 5 to R6, store result in R7

    beq     R7, R6, equal   # If R7 equals R6, branch to label 'equal'
    j       continue        # Unconditional jump to label 'continue'

equal:                      # Label for equal condition
    addi    R7, R7, 1       # Just an example, increment R7 to show we were here

continue:                   # Label to continue execution
    bne     R7, R6, notequal # If R7 not equal to R6, branch to label 'notequal'
    j       end              # Jump to end, skipping the notequal section

notequal:                   # Label for not equal condition
    sub     R7, R7, R6      # Example operation for not equal path

end:                        # End label, could be used for graceful exit
    # End of program. In real assembly, you might want to loop or exit.
    # Since this is for assembler testing, we'll end here.