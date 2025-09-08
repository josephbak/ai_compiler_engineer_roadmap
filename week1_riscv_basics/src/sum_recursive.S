# sum_recursive.S — sum(1..10) using recursion on RV64 Linux (no libc)

    .section .text
    .globl _start

# --- int sum(long n): returns sum(1..n) in a0 ---
# Calling convention notes:
#  - arg n is in a0, return in a0 (psABI)
#  - we create a 16-byte stack frame, save ra and n (so we can add n after the recursive call)
#  - stack must stay 16-byte aligned at call boundaries
sum:
    addi  sp, sp, -16     # make stack frame (keep 16B alignment)  [psABI]
    sd    ra, 8(sp)       # save return address
    sd    a0, 0(sp)       # save n (we'll need it after recursive call)

    beqz  a0, .Lbase      # if (n == 0) return 0;

    addi  a0, a0, -1      # a0 = n-1
    call  sum             # a0 = sum(n-1); (recursive call)

    ld    t0, 0(sp)       # t0 = saved n
    add   a0, a0, t0      # a0 = sum(n-1) + n

    ld    ra, 8(sp)       # restore return address
    addi  sp, sp, 16      # pop frame
    ret

.Lbase:
    mv    a0, zero        # return 0
    ld    ra, 8(sp)
    addi  sp, sp, 16
    ret

# --- _start: entry point ---
_start:
    li    a0, 10          # n = 10
    call  sum             # a0 = sum(1..10) = 55

    # Convert a0 (result) to decimal ASCII into [buf .. buf_end)
    mv    t2, a0          # t2 = value to print
    li    t3, 10          # divisor = 10
    la    t5, buf_end     # t5 = write ptr (one-past-end)
    li    t6, 0           # t6 = digit count

1:  rem   t4, t2, t3      # t4 = value % 10
    addi  t4, t4, '0'     # ASCII digit
    addi  t5, t5, -1      # move back one byte
    sb    t4, 0(t5)       # store digit
    addi  t6, t6, 1       # count++
    div   t2, t2, t3      # value /= 10
    bnez  t2, 1b          # loop until value==0

    # write(1, t5, t6)
    li    a7, 64          # __NR_write
    li    a0, 1           # fd = stdout
    mv    a1, t5          # buf start
    mv    a2, t6          # length
    ecall                  # -> kernel  (ret in a0)

    # write(1, "\n", 1)
    li    a7, 64
    li    a0, 1
    la    a1, nl
    li    a2, 1
    ecall

    # exit(0)
    li    a7, 93          # __NR_exit
    li    a0, 0
    ecall

    .section .rodata
nl: .asciz "\n"

    .section .bss
    .align 1
buf:     .zero 32
buf_end: