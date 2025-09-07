# caller_leaf.s — call mul_u32_leaf in same file

    .text
    .globl __start
__start:
    li   a0, 3
    li   a1, 4
    jal  ra, mul_u32_leaf    # call function

    # print result (12)
    li   t0, 1               # Venus: print int
    mv   a1, a0
    mv   a0, t0
    ecall

    li   a0, 10              # exit
    ecall

# function definition (same file)
    .globl mul_u32_leaf
mul_u32_leaf:
    mv   t0, a0     # copy arg1 into t0
    mv   t1, a1     # copy arg2 into t1
    li   t2, 0      # result accumulator = 0
1:
    beqz t1, 2f
    add  t2, t2, t0
    addi t1, t1, -1
    j    1b
2:
    mv   a0, t2
    jr   ra
