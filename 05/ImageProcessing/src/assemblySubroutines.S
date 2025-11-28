/*
.globl ColourToGrey_Pixel

.text

ColourToGrey_Pixel:

    li x28, 306
    mul a0, a0, x28

    li x28, 601
    mul a1, a1, x28

    li x28, 117
    mul a2, a2, x28

    add a0, a0, a1
    add a0, a0, a2

    srl a0, a0, 10

  	ret

.end
*/

/**/

.globl ColourToGrey

.equ N, 256
.equ M, 256

.text

ColourToGrey:
    
    # save registers to stack
    addi sp, sp, -16
    sw  ra, 0(sp)
    sw  s0, 4(sp) # Greyscale array pixel address iterator (also pixel_index (row-major))
    sw  s1, 8(sp) # Upper-limit (exclusive) for Greyscale array pixel address iterator
    sw  s2, 12(sp) # RGB array pixel address iterator

    # compute upper-limit (exclusive) for Greyscale array pixel address iterator 
    li  t0, N
    li  t1, M
    mul t0, t0, t1
    add s1, a1, t0

    # initialize iterators
    add s0, a1, zero
    add s2, a0, zero

loop1:
    bge s0, s1, endloop1

    # get RGB values and call ColourToGrey_Pixel
    lbu  a0, 0(s2)
    lbu  a1, 1(s2)
    lbu  a2, 2(s2)
    call ColourToGrey_Pixel

    # save brightness to greyscale array
    sb  a0, 0(s0)

    addi s0, s0, 1 # increment Greyscale array pixel address iterator by 1 char
    addi s2, s2, 3 # increment RGB array pixel address iterator by 3 chars
    j loop1

endloop1:

    # reload the registers in the stack and return
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    addi sp, sp, 16
    ret
.end
/**/