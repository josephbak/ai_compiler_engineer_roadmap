# mult_add.s — compute 6 * 7 by repeated addition (RV32I, Venus)

    .text
    .globl __start
__start:
    li   t0, 6        # multiplicand
    li   t1, 7        # multiplier (loop counter)
    li   t2, 0        # acc = 0

loop:
    add  t2, t2, t0   # acc += multiplicand
    addi t1, t1, -1   # multiplier--
    bnez t1, loop     # repeat until multiplier == 0

    # print result (42)
    li   a0, 1        # print int
    mv   a1, t2
    ecall

    li   a0, 10       # exit
    ecall