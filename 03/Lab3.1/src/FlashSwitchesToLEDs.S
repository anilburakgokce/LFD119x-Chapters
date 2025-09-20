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

  li t2, 0x00         # set counter to 0
  li t3, 0x00         # set flash_on to 0

repeat:
  ; lw   t1, 0(t0)      # read switches: t1 = GPIO_SWs
  li t1, 0x1f430000   # set switches for test
  srli t1, t1, 16     # shift val to the right by 16 bits
  addi t2, t2, 1      # increment the counter

  li   t4, 0x1000
  blt  t2, t4, repeat # continue if counter < 0x1000

  li t4, 0xffff       
  xor t3, t3, t4      # Toggle light_on

  and  t1, t1, t3     # Toggle lights
  sw   t1, 4(t0)      # write value to LEDs: GPIO_LEDs = t1

  li   t2, 0          # reset the counter

  j    repeat         # repeat loop
