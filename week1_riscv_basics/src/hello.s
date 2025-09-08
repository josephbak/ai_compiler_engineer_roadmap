
    .section .text
    .globl _start
_start:
    # write(1, msg, len)
    li   a7, 64            # Linux RISC-V syscall: write
    li   a0, 1             # fd = stdout
    la   a1, msg           # buf
    li   a2, msg_end - msg # count
    ecall                  # → trap into kernel, handle write(), return to user mode

    # exit(0)
    li   a7, 93            # Linux RISC-V syscall: exit
    li   a0, 0
    ecall                  # → trap into kernel, handle exit(), process ends

    .section .rodata
msg:
    .asciz "Hello world!\n"
msg_end:



# RV2I — Venus syscalls
# Prints "Hello RISC-V!" then exits

#     .text
#     .globl __start
# __start:
#     li a0, 4          # ecall: print string
#     la a1, msg
#     ecall

#     li a0, 10         # ecall: exit
#     ecall

#     .data
# msg: .asciiz "Hello RISC-V!\n"

# .globl _star
# .section .text

# _start:
#     li a0, 1
#     la a1, hello
#     li a2, 13
#     li a7, 64
#     ecall

#     li a0, 2
#     li a7, 93
#     ecall

# .section .data
# hello: .ascii "Hello world!\n"