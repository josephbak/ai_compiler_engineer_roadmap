# caller
    .text
    .globl __start
__start:
    li   a0, 5
    li   a1, 7
    li   a2, 3
    jal  ra, mul_times_add     # expect 5*7 + 3 = 38

    # print result (38)
    li   t0, 1                 # Venus: print int
    mv   a1, a0
    mv   a0, t0
    ecall
    li   a0, 10
    ecall

# a0 = a0*a1 + a2  (non-leaf)
    .globl mul_times_add
mul_times_add:
    addi sp, sp, -16           # --- prologue: open 16B stack frame
    sw   ra, 12(sp)            # save caller's return address
    sw   s0, 8(sp)             # save s0 (callee-saved) in case we use it
    mv   s0, a2                # keep addend in s0 (safe across calls)

    # call leaf multiplier: a0=arg1, a1=arg2 already set
    jal  ra, mul_u32_leaf      # returns product in a0

    add  a0, a0, s0            # add saved addend

    lw   s0, 8(sp)             # --- epilogue: restore saved regs
    lw   ra, 12(sp)
    addi sp, sp, 16            # close stack frame
    jr   ra                    # return to caller

# leaf helper: a0 = a0 * a1  (repeated addition)
    .globl mul_u32_leaf
mul_u32_leaf:
    mv   t0, a0
    mv   t1, a1
    li   t2, 0
1:
    beqz t1, 2f
    add  t2, t2, t0
    addi t1, t1, -1
    j    1b
2:
    mv   a0, t2
    jr   ra
