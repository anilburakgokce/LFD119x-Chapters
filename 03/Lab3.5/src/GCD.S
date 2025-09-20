.globl main

# assume the inputs are in a1 and a2
# return result at a0
main:

  # set test cases
  li a2, 36
  li a1, 24

gcd:
  beqz a1, aone
  beqz a2, atwo

process:
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

  j   main
