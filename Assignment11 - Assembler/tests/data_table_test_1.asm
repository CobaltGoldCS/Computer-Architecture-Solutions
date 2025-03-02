.data
    word1: 10
    word2: 20
    word3: 30
    result: 0

.text
main:
    # Load the values of word1, word2, and word3 into registers
    lw R0, word1
    lw R1, word2
    lw R2, word3

    # Add word1 and word2, and store the result in $t3
    add R3, R0, R1

    # Subtract word3 from the sum, and store the result in $t4
    sub R4, R3, R2
    
    # Add 10 to the result, and store the result in $t5
    addi R5, R4, 10

    # Store the final result in the 'result' variable
    sw R5, result