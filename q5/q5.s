    .section .data
filename:
    .asciz "input.txt"

yes_msg:
    .asciz "Yes\n"

no_msg:
    .asciz "No\n"

    .section .bss
    .align 1
left_buf:
    .skip 1
right_buf:
    .skip 1

    .section .text
    .globl main

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)

    li a0, -100
    la a1, filename
    li a2, 0
    li a3, 0
    li a7, 56
    ecall
    mv s0, a0                  # s0 = fd

    mv a0, s0
    li a1, 0
    li a2, 2
    li a7, 62
    ecall
    mv s1, a0                  # s1 = len

    li t0, 1
    ble s1, t0, print_yes

    li s2, 0                   # left = 0
    addi s3, s1, -1            # right = len - 1

loop:
    bge s2, s3, print_yes
    mv a0, s0
    mv a1, s2
    li a2, 0
    li a7, 62
    ecall

    mv a0, s0
    la a1, left_buf
    li a2, 1
    li a7, 63
    ecall

    mv a0, s0
    mv a1, s3
    li a2, 0
    li a7, 62
    ecall

    mv a0, s0
    la a1, right_buf
    li a2, 1
    li a7, 63
    ecall

    la t0, left_buf
    lbu t1, 0(t0)
    la t0, right_buf
    lbu t2, 0(t0)
    bne t1, t2, print_no

    addi s2, s2, 1
    addi s3, s3, -1
    j loop

print_yes:

    li a0, 1
    la a1, yes_msg
    li a2, 4
    li a7, 64
    ecall
    li a0, 0
    j done

print_no:

    li a0, 1
    la a1, no_msg
    li a2, 3
    li a7, 64
    ecall
    li a0, 0

done:

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    addi sp, sp, 48
    ret
    