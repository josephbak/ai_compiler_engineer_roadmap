# loop_linux.S — Sum 1..10, print result on Linux (RV64), no libc

    .section .text
    .globl _start
_start:
    # --- Initialize loop variables (all 64-bit regs on RV64) ---
    li    t0, 1              # t0 = i = 1
    li    t1, 11             # t1 = stop value (we'll loop while i < 11)
    li    t2, 0              # t2 = sum = 0

loop:
    add   t2, t2, t0         # sum += i
    addi  t0, t0, 1          # i++
    blt   t0, t1, loop       # if (i < 11) continue

    # --- Convert integer sum in t2 to ASCII decimal in buffer (no stack) ---
    # Build digits backwards starting at buf_end, then write from that point.
    la    t5, buf_end        # t5 = write pointer (one-past-end)
    li    t6, 0              # t6 = digit count = 0
    li    t3, 10             # constant 10 for div/rem

conv_loop:
    rem   t4, t2, t3         # t4 = t2 % 10      (extract least-significant digit)
    addi  t4, t4, '0'        # t4 = ASCII('0' + digit)
    addi  t5, t5, -1         # move back one byte
    sb    t4, 0(t5)          # store ASCII digit at [t5]
    addi  t6, t6, 1          # digit count++
    div   t2, t2, t3         # t2 = t2 / 10
    bnez  t2, conv_loop      # loop until all digits consumed

    # --- write(1, t5, t6)  → print the number ---
    # Linux RISC-V syscall ABI: a7=syscall#, a0..a5=args, ecall triggers kernel.
    # write has number 64; args are (fd, buf, count) = (a0, a1, a2). :contentReference[oaicite:1]{index=1}
    li    a7, 64             # __NR_write
    li    a0, 1              # fd = 1 (stdout)
    mv    a1, t5             # buf = pointer to first digit
    mv    a2, t6             # count = number of bytes
    ecall                    # into the kernel; return value in a0. :contentReference[oaicite:2]{index=2}

    # --- write(1, "\n", 1) ---
    li    a7, 64
    li    a0, 1
    la    a1, nl
    li    a2, 1
    ecall

    # --- exit(0) ---
    # exit has number 93; a0 = status. :contentReference[oaicite:3]{index=3}
    li    a7, 93
    li    a0, 0
    ecall

    .section .rodata
nl: .asciz "\n"

    .section .bss
    .align 1
buf:    .zero 32             # small scratch for digits (overkill for "55")
buf_end: