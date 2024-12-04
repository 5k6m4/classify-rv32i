.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)            # current max value

    li t1, 0                # index for currnet max element
    li t2, 1                # start checking from the second element

loop_start:
    bge t2, a1, done
    slli t3, t2, 2          # t3 = t2 * 2
    add t3, a0, t3          # pointer address of each element
    lw t4, 0(t3)            # load element, t4 = element
    blt t0, t4, update_max  # new element > current max
    j skip_update 

update_max:
    addi t0, t4, 0         # update max value
    addi t1, t2, 0         # update index of max element

skip_update:
    addi t2, t2, 1          # index increment
    j loop_start

done:
    addi a0, t1, 0
    jr ra

handle_error:
    li a0, 36
    j exit
