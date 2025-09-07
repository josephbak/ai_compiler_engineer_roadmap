# mem_io.s — Store values into an array and reload them

    .text
    .globl __start
__start:
    la   t0, array    # t0 = base address of array

    li   t1, 123      # first value
    sw   t1, 0(t0)    # store at array[0]

    li   t1, 456      # second value
    sw   t1, 4(t0)    # store at array[1]

    # load them back
    lw   t2, 0(t0)    # t2 = array[0]
    lw   t3, 4(t0)    # t3 = array[1]

    # print both values
    li   a0, 1        # print int
    mv   a1, t2
    ecall

    li   a0, 4        # print string (space)
    la   a1, space
    ecall

    li   a0, 1
    mv   a1, t3
    ecall

    li   a0, 10       # exit
    ecall

    .data
array: .space 8        # reserve 8 bytes (2 words)
space: .asciiz " "
