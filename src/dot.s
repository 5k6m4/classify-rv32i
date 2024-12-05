.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0                    # t0 = result
    li t1, 0                    # t1 = loop index

loop_start:
    bge t1, a2, loop_end

# Count i(loop index) * s(stride) of the first array
    li t2, 0                    # t2 = i * s result of first array
    addi t3, t1, 0              # t3 = multiplicand
    addi t4, a3, 0              # t4 = multiplier

loop_1:
    beq t4, x0, loop_end_1      # if multiplier = 0, end multiplication
    andi t5, t4, 1              # get multiplier LSB
    beq t5, x0, skip_add_1      # if LSB = 0, end add multiplicand
    add t2, t2, t3              # add multiplicand to result

skip_add_1:
    slli t3, t3, 1              # multiply multiplicand by 2
    srli t4, t4, 1              # get multiplier next bit 
    j loop_1

# Get first array element
loop_end_1:
    slli t3, t2, 2              # byte distance
    add t3, a0, t3              # address of first array element
    lw t2, 0(t3)                # t2(multiplicand) = first array element

# Count i(loop index) * s(stride) of second array
    li t3, 0                    # t3 = i * s result of second array
    addi t4, t1, 0              # t4 = multiplicand
    addi t5, a4, 0              # t5 = multiplier

loop_2:
    beq t5, x0, loop_end_2      # if multiplier = 0, end multiplication
    andi t6, t5, 1              # get multiplier LSB
    beq t6, x0, skip_add_2      # if LSB = 0, end add multiplicand
    add t3, t3, t4              # add multiplicand to result

skip_add_2:
    slli t4, t4, 1              # multiply multiplicand by 2
    srli t5, t5, 1              # get multiplier next bit 
    j loop_2

# Get second array element
loop_end_2:
    slli t4, t3, 2              # byte distance
    add t4, a1, t4              # address of second array element
    lw t3, 0(t4)                # t3(multiplier) = second array element

# Count v0[i](t2) * v1[i](t3)
    li t5, 0                    # t5 = result of v0[i] * v1[i]

loop_res:
    beq t3, x0, loop_end_res    # if multiplier = 0, end multiplication
    andi t4, t3, 1              # get multiplier LSB
    beq t4, x0, skip_add_res    # if LSB = 0, end add multiplicand
    add t5, t5, t2              # add multiplcand to the final result

skip_add_res:
    slli t2, t2, 1              # multiply multiplicand by 2
    srli t3, t3, 1              # get multiplier next bit
    j loop_res

loop_end_res:
    add t0, t0, t5
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
