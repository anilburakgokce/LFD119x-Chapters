.globl main

# return the address of the result vector at a0
main:

  la  a0, A

run:
  li    t1, 0     # initialize the index
  li    a1, 0     # initialize "switch_occured" flag

iterate:
  # read numbers
  slli  t2, t1, 2
  add   t2, a0, t2
  lw    a2, (t2)  # read A[t1]
  lw    a3, 4(t2) # read A[t1 + 1]

  ble   a2, a3, continue

  # switch numbers
  sw    a3, (t2)
  sw    a2, 4(t2)
  li    a1, 1     # set "switch_occured" flag

continue:
  addi  t1, t1, 1 # increment the index
  li    t2, 11    # set limit to 11=12-1
  blt   t1, t2, iterate

  # restart if switch happened
  xori  a1, a1, 1
  beq   a1, zero, run

  j   main

.data
A: .word 0,1,2,7,-8,4,5,12,11,-2,6,3
