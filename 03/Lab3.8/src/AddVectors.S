.globl main

# return the address of the result vector at a0
main:

  la    a0, C
  la    a1, A
  la    a2, B

  li    a3, 12    # set the length of the vectors
  li    a4, 0     # set the iterator to zero

iterate:
  slli  t4, a4, 2 # compute the offset

  add   t5, a1, t4 
  lw    t1, (t5)

  add   t5, a2, t4 
  lw    t2, (t5)

  add   t0, t1, t2

  add   t5, a0, t4 
  sw    t0, (t5)

  addi  a4, a4, 1 # increment the iterator

  blt   a4, a3, iterate

  j   main

.data
A: .word 0,1,2,7,-8,4,5,12,11,-2,6,3
B: .word 0,1,2,7,-8,4,5,12,11,-2,6,3
C: .word 0,0,0,0,0,0,0,0,0,0,0,0
