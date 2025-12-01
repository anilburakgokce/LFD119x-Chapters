# memory-mapped I/O addresses
# GPIO_IN     = 0x80001400
# GPIO_OUT    = 0x80001404
# GPIO_INOUT  = 0x80001408
# GPIO2_PBs   = 0x80001800
# GPIO2_INOUT = 0x80001808

.globl main

.equ slowStepTime, 0x2000
.equ fastStepTime, 0x800
.equ gpio2_offset, 0x400

main:
    # enter main
    addi sp, sp, -32
    sw  ra, 0(sp)
    sw  s0, 4(sp) # address of GPIO registers
    sw  s1, 8(sp) # counter
    sw  s2, 12(sp) # previous buttons
    sw  s3, 16(sp) # LED values
    sw  s4, 20(sp) # stepTime


    li  s0, 0x80001400   # base address of GPIO memory-mapped registers
    li  t1, 0xFFFF       # set direction of GPIOs
                        # upper half = switches (inputs)  (=0)
                        # lower half = outputs (LEDs)     (=1)
    sw  t1, 8(s0)        # GPIO_INOUT = 0xFFFF

    addi t0, s0, gpio2_offset
    sw  zero, 8(t0)   # GPIO2_INOUT = 0xFFFF

    li  s1, 0 # set counter to 0
    li  s3, 1 # reset LED values
    sw  s3, 4(s0) # write value to LEDs
    li  s4, slowStepTime # set initial speed to slow

repeat:
    # read buttons
    # buttons[0] = upper button, buttons[1] = center button
    lw  t1, gpio2_offset(s0)
    andi t1, t1, 3

    # check upper button state
    andi t0, s2, 1
    beqz t0, check_prev_bit1
    andi t0, t1, 1
    bnez t0, check_prev_bit1

    # reset LEDs and counter
    li  s3, 1 # reset LED values
    li  s1, 0 # reset the counter
    sw  s3, 4(s0)      # write value to LEDs

check_prev_bit1:
    # check center button state
    srli t0, s2, 1
    andi t0, t0, 1
    beqz t0, buttons_check_end
    srli t0, t1, 1
    andi t0, t0, 1
    bnez t0, buttons_check_end
    li  t0, slowStepTime
    xor s4, s4, t0
    li  t0, fastStepTime
    xor s4, s4, t0

buttons_check_end:
    mv  s2, t1 # update previous button values

    addi s1, s1, 1 # increment counter

    blt s1, s4, repeat # if not time, go back to beginning

    li  s1, 0 # reset the counter
    sw  s3, 4(s0)      # write value to LEDs
    addi s3, s3, 1 # increment LED values
    j   repeat         # repeat loop

    # exit main
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp) # LED values
    lw  s4, 20(sp) # stepTime
    addi sp, sp, 32

    ret
