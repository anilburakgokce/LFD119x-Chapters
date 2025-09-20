// memory-mapped I/O addresses
# GPIO_SWs   = 0x80001400
# GPIO_LEDs  = 0x80001404
# GPIO_INOUT = 0x80001408

.globl main


main:
  li    t0, 0x80001400    # base address of GPIO memory-mapped registers
  li    t1, 0xFFFF        # set direction of GPIOs
                          # upper half = switches (inputs)  (=0)
                          # lower half = outputs (LEDs)     (=1)
  sw    t1, 8(t0)         # GPIO_INOUT = 0xFFFF

repeat:

  li    t2, 1             # set led_count = 1
  
run:
  # calculate led configuration
  li    t3, 1
  sll   t1, t3, t2
  sub   t1, t1, t3     # t1 = (1 << led_count) - 1

  li    t3, 0           # set t3 as the iterator
  li    t4, 16
  sub   t4, t4, t2    # set limit for moves

loop1:
  sw    t1, 4(t0)      # write value to LEDs: GPIO_LEDs = t1
  addi  t3, t3, 1        # increment the iterator
  slli  t1, t1, 1       # move leds one up
  blt   t3, t4, loop1   

  sw    t1, 4(t0)      # handle the edge case
  srli  t1, t1, 1       # move leds one down
  
  li    t3, 0           # set t3 as the iterator

loop2:
  sw    t1, 4(t0)      # write value to LEDs: GPIO_LEDs = t1
  addi  t3, t3, 1        # increment the iterator
  srli  t1, t1, 1       # move leds one down
  blt   t3, t4, loop2   

  li    t4, 17
  addi  t2, t2, 1     # increment led_count
  blt   t2, t4, run

  j     repeat         # repeat loop
