.globl main

# return the address of the vector at a0
main:

  la    a0, B
  la    a3, A         # load the address of the array
  li    a4, 12        # set iteration length

  li    t0, 0         # initiate the iterator for A to 0
  li    t1, 0         # initiate the iterator for B to 0
iterate:

  # compute the address of the (t0)th element
  slli  t2, t0, 2
  add   t2, a3, t2

  lw    a1, (t2)      # load A[t0]

  addi  t0, t0, 1     # increment the iterator for A

  # continue if a1 <= 0
  ble   a1, zero, continue

  # continue if not even
  andi  t2, a1, 1
  xori  t2, t2, 1
  beq   t2, zero, continue

  # compute the address of the (t1)th element
  slli  t2, t1, 2
  add   t2, a0, t2

  sw    a1, (t2)    # store B[t1]

  addi  t1, t1, 1   # increment the iterator for B

continue:

  blt   t0, a4, iterate

  j   main

.data
A: .word 0,1,2,7,-8,4,5,12,11,-2,6,3
B: .word 0,0,0,0,0,0,0,0,0,0,0,0
