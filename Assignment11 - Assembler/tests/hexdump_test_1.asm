.data
    var1: 10
    var2:  20
    var3: 30
       var4: 40
    var5: 50
 result:  0

.text
main:
    # Load variables into registers
    lw R1,var1
    lw R2, var2
    lw R3, var3
         lw R4,var4
lw R5, var5

    # Perform arithmetic operations
    add R6, R1, R2    # Add var1 and var2, store the result in R6
    sub R7, R3, R4    # Subtract var4 from var3, store the result in R7

    # Call the multiplication function to multiply var5 by 2
    add R1, R5, R0    # Move var5 to R1 (first argument)
    addi R2, R0, 2    # Set the second argument (multiplier) to 2
    jal multiply      # Call the multiply function
    add R6, R1, R0    # Move the result from R1 to R6

    # Store the results back into memory
    sw R6, result     # Store the sum of var1 and var2 in 'result'
    sw R7, var4       # Update var4 with the difference of var3 and var4
    sw R6, var5       # Update var5 with its doubled value

    # Load the updated values back into registers
    lw R4,var4
    lw R5, var5

    # Perform more arithmetic operations
    add R6, R6, R4    # Add the sum of var1 and var2 with the updated var4
    sub R7, R5, R6    # Subtract the doubled var5 from the updated var5

    # Store the final results back into memory
    sw R6, result     # Store the final sum in 'result'
    sw R7, var5       # Update var5 with the final difference

    # End of program
        j end

multiply:
    # Multiplication function
    # Arguments: R1 - multiplicand, R2 - multiplier
    # Returns: R1 - product
    addi R3, R0, 0    # Initialize the product to 0
    addi R4, R0, 0    # Initialize the loop counter to 0

    multiply_loop:
        beq R4,R2,multiply_end   # If the loop counter equals the multiplier, end the loop
        add R3, R3,R1             # Add the multiplicand to the product
        addi R4, R4, 1             # Increment the loop counter
        j multiply_loop            # Jump back to the start of the loop

    multiply_end:
        add R1, R3, R0    # Move the final product to R1
        jr R7             # Return from the multiplication function

end: