.data
arr:        .space 400
stack:      .space 400
result_arr: .space 400

fmt: .asciz "%d "
nl:  .asciz "\n"

.text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)
    sd s6, 0(sp)

    mv s0, a1              # argv pointer
    mv s1, a0              # n

    ble s1, zero, finish

    li s3, 0

input_loop:
    bge s3, s1, input_done

    ld a0, 0(s0)
    call atoi

    la t0, arr
    slli t1, s3, 2
    add t0, t0, t1
    sw a0, 0(t0)

    addi s0, s0, 8
    addi s3, s3, 1
    j input_loop

input_done:
    li s3, 0

init_loop:
    bge s3, s1, init_done
    la t0, result_arr
    slli t1, s3, 2
    add t0, t0, t1
    li t2, -1
    sw t2, 0(t0)

    addi s3, s3, 1
    j init_loop

init_done:
    li s2, -1
    addi s3, s1, -1

outer_loop:
    blt s3, zero, print_phase

while_loop:
    blt s2, zero, while_done

    la t0, stack
    slli t1, s2, 2
    add t0, t0, t1
    lw s4, 0(t0)           # top index

    la t0, arr
    slli t1, s4, 2
    add t0, t0, t1
    lw s5, 0(t0)           # arr[top]

    la t0, arr
    slli t1, s3, 2
    add t0, t0, t1
    lw s6, 0(t0)           # arr[i]

    ble s5, s6, pop_stack
    j while_done

pop_stack:
    addi s2, s2, -1
    j while_loop

while_done:
    blt s2, zero, push_current

    la t0, stack
    slli t1, s2, 2
    add t0, t0, t1
    lw t2, 0(t0)

    la t0, result_arr
    slli t1, s3, 2
    add t0, t0, t1
    sw t2, 0(t0)

push_current:
    addi s2, s2, 1
    la t0, stack
    slli t1, s2, 2
    add t0, t0, t1
    sw s3, 0(t0)

    addi s3, s3, -1
    j outer_loop

print_phase:
    li s3, 0

print_loop:
    bge s3, s1, finish

    la t0, result_arr
    slli t1, s3, 2
    add t0, t0, t1
    lw a1, 0(t0)

    la a0, fmt
    call printf

    addi s3, s3, 1
    j print_loop

finish:
    la a0, nl
    call printf

    li a0, 0
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    ld s6, 0(sp)
    addi sp, sp, 64
    ret
