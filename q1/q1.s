.section .text

.globl make_node
make_node:
    addi sp, sp, -16
    sd ra, 8(sp)

    mv t1, a0          # save val

    li a0, 24          # size of struct
    call malloc

    mv t0, a0          # node pointer

    sw t1, 0(t0)       # node->val = val
    sd zero, 8(t0)     # node->left = NULL
    sd zero, 16(t0)    # node->right = NULL

    mv a0, t0

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

.globl insert
insert:
    addi sp, sp, -32      
    sd ra, 24(sp)
    sd a0, 0(sp)
    sd a1, 8(sp)

    beqz a0, insert_new

    lw t0, 0(a0)

    ld a1, 8(sp)
    blt a1, t0, go_left

# RIGHT
    ld t1, 16(a0)

    ld a1, 8(sp)
    mv a0, t1
    call insert

    ld t2, 0(sp)
    sd a0, 16(t2)

    mv a0, t2
    j insert_end

# LEFT
go_left:
    ld t1, 8(a0)

    ld a1, 8(sp)
    mv a0, t1
    call insert

    ld t2, 0(sp)
    sd a0, 8(t2)

    mv a0, t2
    j insert_end

insert_new:
    ld a0, 8(sp)
    call make_node

insert_end:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

.globl get
get:
    beqz a0, not_found

    lw t0, 0(a0)

    beq t0, a1, found
    blt a1, t0, go_left_g

# right
    ld a0, 16(a0)
    j get

go_left_g:
    ld a0, 8(a0)
    j get

found:
    ret

not_found:
    li a0, 0
    ret

.globl getAtMost
getAtMost:
    li t1, -1          # answer = -1

loop:
    beqz a1, done

    lw t0, 0(a1)

    bgt t0, a0, go_left2

    mv t1, t0
    ld a1, 16(a1)
    j loop

go_left2:
    ld a1, 8(a1)
    j loop

done:
    mv a0, t1
    ret
