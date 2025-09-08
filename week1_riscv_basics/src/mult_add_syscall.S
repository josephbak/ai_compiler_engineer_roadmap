# mult_add_syscall_commented.S — RV64 Linux, pure syscalls, no stack
    .section .text
    .globl _start
_start:
    # --- Multiply 6 * 7 by repeated addition ---
    li    t0, 6             # t0 = multiplicand (6)
    li    t1, 7             # t1 = loop counter (multiplier)
    li    t2, 0             # t2 = accumulator (initially 0)

loop_mul:
    add   t2, t2, t0        # t2 += t0
    addi  t1, t1, -1        # t1--
    bnez  t1, loop_mul      # if t1 != 0, repeat loop

    # --- Convert t2 to ASCII string (decimal) backward in buffer ---
    la    t5, buf_end       # t5 points just after buffer
    li    t6, 0             # t6 = digit count = 0
    li    t3, 10            # divisor = 10

convert_digit:
    rem   t4, t2, t3        # t4 = t2 % 10
    addi  t4, t4, '0'       # convert to ASCII ('0' + digit)
    addi  t5, t5, -1        # move t5 backward
    sb    t4, 0(t5)         # store char at *t5
    addi  t6, t6, 1         # increment digit count
    div   t2, t2, t3        # t2 = t2 / 10
    bnez  t2, convert_digit # if t2 != 0, continue looping

    # --- Syscall: write(fd=1, buf, count) ---
    li    a7, 64            # syscall number for write (riscv64)
    li    a0, 1             # fd = stdout
    mv    a1, t5            # a1 = pointer to first digit char
    mv    a2, t6            # a2 = digit count
    ecall                   # perform the syscall, returns bytes written in a0

    # --- Write newline character ---
    li    a7, 64            # write syscall again
    li    a0, 1
    la    a1, nl            # address of newline
    li    a2, 1             # write one byte
    ecall

    # --- Syscall: exit(0) ---
    li    a7, 93            # syscall number for exit (riscv64)
    li    a0, 0             # exit code 0
    ecall

    .section .rodata
nl: .asciz "\n"              # newline string for print

    .section .bss
    .align  1
buf:       .zero 32          # allocate 32-byte buffer for number
buf_end:



# # mult_add.s — compute 6 * 7 by repeated addition (RV32I, Venus)

#     .text
#     .globl __start
# __start:
#     li   t0, 6        # multiplicand
#     li   t1, 7        # multiplier (loop counter)
#     li   t2, 0        # acc = 0

# loop:
#     add  t2, t2, t0   # acc += multiplicand
#     addi t1, t1, -1   # multiplier--
#     bnez t1, loop     # repeat until multiplier == 0

#     # print result (42)
#     li   a0, 1        # print int
#     mv   a1, t2
#     ecall

#     li   a0, 10       # exit
#     ecall