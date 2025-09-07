# loop.s — Sum numbers 1..10 and print result

    .text
    .globl __start
__start:
    li   t0, 1        # i = 1
    li   t1, 11       # stop value = 11
    li   t2, 0        # sum = 0

loop:
    add  t2, t2, t0   # sum += i
    addi t0, t0, 1    # i++
    blt  t0, t1, loop # if (i < 11) repeat

    # print result
    li   a0, 1        # Venus: print int
    mv   a1, t2
    ecall

    # newline
    li   a0, 4
    la   a1, nl
    ecall

    li   a0, 10       # exit
    ecall

    .data
nl: .asciiz "\n"