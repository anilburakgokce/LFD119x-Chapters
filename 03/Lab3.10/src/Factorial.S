.globl main

# input is taken through a1, and the result is returned at a0
main:

  li    a1, 7     # set input for testing
  li    a0, 1     # set output to 1
  li    t0, 2     # set the iterator to 2

iterate:
  mul   a0, a0, t0
  addi  t0, t0, 1 # increment the iterator
  ble   t0, a1, iterate

  j     main
