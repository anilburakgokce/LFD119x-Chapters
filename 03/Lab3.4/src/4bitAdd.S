// memory-mapped I/O addresses
# GPIO_SWs   = 0x80001400
# GPIO_LEDs  = 0x80001404
# GPIO_INOUT = 0x80001408

.globl main


main:
  li t0, 0x80001400   # base address of GPIO memory-mapped registers
  li t1, 0xFFFF       # set direction of GPIOs
                      # upper half = switches (inputs)  (=0)
                      # lower half = outputs (LEDs)     (=1)
  sw t1, 8(t0)        # GPIO_INOUT = 0xFFFF

repeat:
;   lw   t1, 0(t0)      # read switches: t1 = GPIO_SWs
  li   t1, 0x5f4c0000     # set switch values for testing
  srli t2, t1, 16
  andi t2, t2, 0xf    # get the first 4-bit number
  srli t3, t1, 28     # get the second 4-bit number
  
  add  t1, t2, t3     # compute result

  sw   t1, 4(t0)      # write value to LEDs: GPIO_LEDs = t1
  
  j    repeat         # repeat loop
