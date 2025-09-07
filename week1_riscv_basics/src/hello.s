# RV32I — Venus syscalls
# Prints "Hello RISC-V!" then exits

    .text
    .globl __start
__start:
    li a0, 4          # ecall: print string
    la a1, msg
    ecall

    li a0, 10         # ecall: exit
    ecall

    .data
msg: .asciiz "Hello RISC-V!\n"