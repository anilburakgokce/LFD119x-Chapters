.globl main

.equ N, 6

.data
A: .word 48,64,56,80,96,48
B: .word 0,0,0,0,0,0

.text

# takes inputs at a0 and a1
# returns the result at a0
myFilter:
    # init result as 0
    li  t0, 0

    # check if a0 % 16 == 0
    andi t1, a0, 15 
    bne t1, zero, myFilter_end

    # check if a0 < a1
    bge a0, a1, myFilter_end

    # set result to 1
    li  t0, 1

myFilter_end:
    addi a0, t0, 0
    ret


main:
    # save registers to stack
    addi sp, sp, -32
    sw  ra, 0(sp)
    sw  s0, 4(sp) # i
    sw  s1, 8(sp) # j
    sw  s2, 12(sp) # N-1
    sw  s3, 16(sp) # A
    sw  s4, 20(sp) # B
    sw  s5, 24(sp) # A[i]
    sw  s6, 28(sp) # A[i+1]


    li  s0, 0 # set i = 0
    li  s1, 0 # set j = 0

    # set s2 tp N-1
    li  s2, N
    addi s2, s2, -1

    la  s3, A
    la  s4, B
    
loop1:
    bge s0, s2, loop1_end

    # compute the address of the elements
    sll t0, s0, 2
    add t0, t0, s3

    # read elements
    lw  s5, (t0)
    lw  s6, 4(t0)

    # call myFilter
    addi a0, s5, 0
    addi a1, s6, 0
    jal myFilter

    addi s0, s0, 1 # increment i

    # continue if myFiler does not return 1
    addi a0, a0, -1
    bne a0, zero, loop1

    # compute B[j]
    add t0, s5, s6
    addi t0, t0, 2

    # compute the target addres for B[j] and save the result
    sll t1, s1, 2
    add t1, t1, s4
    sw  t0, (t1)

    addi s1, s1, 1 # increment j

    j loop1
loop1_end:

    # reload the registers in the stack
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp)
    lw  s4, 20(sp)
    lw  s5, 24(sp)
    lw  s6, 28(sp)
    addi sp, sp, 32

    ret

.end