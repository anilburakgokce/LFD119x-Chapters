.globl main

.equ M, 6

.data
D: .word 3,5,0, 6,18,0, 15,45,0, 13,10,0, 24,3,0, 24,35,0

.text

# inputs a1 and a2: numbers
# return result at a0
gcd:
  beqz a1, aone
  beqz a2, atwo

  rem t0, a1, a2
  add a1, a2, x0
  add a2, t0, x0
  j   gcd

aone:
  add a0, a2, x0
  j   final

atwo:
  add a0, a1, x0

final:
    ret


# input a0: The address of the array
# input a1: position
check_coprime:
    # save registers to stack
    addi sp, sp, -16
    sw  ra, 0(sp)
    sw  s0, 4(sp)

    # find address of the pair
    li  s0, 12 # 12 = 3x4 = size of 3 words
    mul s0, s0, a1
    add s0, s0, a0

    # call gcd
    lw  a1, (s0)
    lw  a2, 4(s0)
    jal gcd

    # compute value to be stored
    addi t1, a0, 1
    addi t0, t1, -2
    beqz t0, save_result
    li t1, 1
save_result:
    sw t1, 8(s0)

    # reload the registers in the stack and return
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    addi sp, sp, 16
    ret


main:
    # save registers to stack
    addi sp, sp, -16
    sw  ra, 0(sp)
    sw  s0, 4(sp) # i

    li  s0, 0 # set i = 0
loop1:
    # end loop1 if i >= M
    li  t0, M
    bge s0, t0, endloop1

    # call check_coprime
    la  a0, D
    add a1, s0, zero
    jal check_coprime

    addi s0, s0, 1 # increment i
    j   loop1

endloop1:

    # reload the registers in the stack and return
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    addi sp, sp, 16
    ret

.end