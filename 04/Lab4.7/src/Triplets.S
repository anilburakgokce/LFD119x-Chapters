.globl main

.equ N, 4

.data
A: .word 7,3,25,4,75,2,1,1,3,2,8,4
B: .word 0,0,0,0

.text

# input a0: number
# output a0: absolute value of number
f_abs:
    # set a0 = 0-a0 if a0 < 0
    blt x0, a0, end_abs
    sub a0, x0, a0
end_abs:
    ret


# input a0: address of the array
# input a1: index
# output a0: sum
res_triplet:
    # function intro
    addi sp, sp, -16
    sw  ra, 0(sp)

    slli a1, a1, 2 # mov offset to a1

    add a1, a0, a1 # set the address

    li  a0, 0 # init a0 for summation 
    li  a3, 0 # init a3 for i
    li  t0, 3 # set limit
f_loop_1:
    lw  a2, (a1) # load element
    add a0, a2, a0 # add element
    addi a3, a3, 1 # increment index
    addi a1, a1, 4 # increment address
    blt a3, t0, f_loop_1

    # call abs
    jal f_abs

    # function outro
    lw  ra, (sp)
    addi sp, sp, 16
    ret


main:
    # save registers to stack
    addi sp, sp, -16
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)

    li  s0, 0 # init index j for A
    li  s1, 0 # init index i for B

loop1:
    # call res_triplet for A[j]
    la  a0, A
    xor a1, s0, x0
    jal res_triplet

    # save result to B[i]
    la  t0, B
    slli t1, s1, 2
    add t0, t0, t1
    sw  a0, (t0)

    # increment indices
    addi s0, s0, 3
    addi s1, s1, 1

    # check loop condition and branch
    li  t0, N
    blt s1, t0, loop1

    # reload the registers in the stack
    lw  s1, 8(sp)
    lw  s0, 4(sp)
    lw  ra, 0(sp)
    addi sp, sp, 16

    ret

.end