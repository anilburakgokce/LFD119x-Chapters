.globl main

# return the address of the vector at a0
main:

  li    a1, 0         # set fib_n to 0
  li    a2, 1         # set fib_nm1 to 1
  li    t0, 0         # set fib_i to 0
 
  la    a3, array     # load the address of the array
  li    a4, 12        # set iteration length

process:
  # write array[fib_i]
  sll   t2, t0, 2
  add   t1, a3, t2    # compute address
  sw    a1, (t1)

  # compute next element
  add   t1, a1, zero
  add   a1, a1, a2
  add   a2, t1, 0
  addi  t0, t0, 1

  blt   t0, a4, process

  la   a0, array

  j   main

.data
array: .word 0,0,0,0,0,0,0,0,0,0,0,0
