# memory-mapped I/O addresses
# GPIO_IN     = 0x80001400
# GPIO_OUT    = 0x80001404
# GPIO_INOUT  = 0x80001408

# SegEn_ADDR  = 0x80001038
# SegDig_ADDR = 0x8000103C

.globl main

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

    # enable four 7seg cells
    li  s1, 0x80001038
    li  t0, 0xF0
    sw  t0, (s1)

repeat:
    # read switches
    lw  t0, (s0)
    srli t0, t0, 16

    # convert to decimal representation
    

    # write switches value to 7seg
    sw  t0, 4(s1)

    j repeat

    # exit main
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp) # LED values
    lw  s4, 20(sp) # stepTime
    addi sp, sp, 32

    ret