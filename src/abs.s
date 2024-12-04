.globl abs

.text
# =================================================================
# FUNCTION: Absolute Value Converter
#
# Transforms any integer into its absolute (non-negative) value by
# modifying the original value through pointer dereferencing.
# For example: -5 becomes 5, while 3 remains 3.
#
# Args:
#   a0 (int *): Memory address of the integer to be converted
#
# Returns:
#   None - The operation modifies the value at the pointer address
# =================================================================
abs:
    # Prologue
    ebreak
    # Load number from memory
    lw t0 0(a0)
    bge t0, zero, done

    xori t1, t0, -1 # t1 = 1's compliment of t0
    addi t0, t1, 1  # t0 = 1's compliment of t0 + 1 = abs(t0)
    sw t0 0(a0)     # update the value at the pointer address

done:
    # Epilogue
    jr ra