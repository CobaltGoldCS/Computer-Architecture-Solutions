.text
# Start of program

main:
    # Load immediate values into registers
    li R1, 10
    li R2, 20
    li R3, 30

    # Add the values in R2 and R3, and store the result in R4
    add R4, R2, R3

    # Subtract the value in R4 from the value in R1, and store the result in R5
    sub R5, R4, R1

    # Add the result by 2, and store the result in R6
    addi R6, R5, 2

    # End of program
    j end

end: