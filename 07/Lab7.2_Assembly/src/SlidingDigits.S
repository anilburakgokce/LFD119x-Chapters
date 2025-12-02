# memory-mapped I/O addresses
# GPIO_IN     = 0x80001400
# GPIO_OUT    = 0x80001404
# GPIO_INOUT  = 0x80001408

# SegEn_ADDR  = 0x80001038
# SegDig_ADDR = 0x8000103C

.globl main

.equ stepTime, 0x1000

main:
    # enter main
    addi sp, sp, -32
    sw  ra, 0(sp)
    sw  s0, 4(sp) # address of GPIO registers
    sw  s1, 8(sp) # address of 7 Segment registers
    sw  s2, 12(sp) # 7 Segment value
    sw  s3, 16(sp) # 7 Segment value counter
    sw  s4, 20(sp) # counter
    sw  s5, 24(sp) # enabled 7 segments
    
    # initialize GPIO
    li  s0, 0x80001400   # base address of GPIO memory-mapped registers
    li  t1, 0xFFFF       # set direction of GPIOs
    sw  t1, 8(s0)        # GPIO_INOUT = 0xFFFF

    # initialize the values
    li  s1, 0x80001038
    li  s2, 0
    li  s3, 0
    li  s4, 0
    li  s5, 0xFF

repeat:
    # read switch[0]
    lw  t0, (s0)
    srli t0, t0, 16
    andi t0, t0, 1

    # reset the system and continue if sw[0] is reset
    bnez t0, operate
    li  s2, 0
    li  s3, 0
    li  s4, 0
    li  s5, 0xFF
    sw  s5, (s1)
    j   repeat

operate:
    addi s4,s4, 1 # increment the counter

    # continue to wait if the limit is reached
    li  t0, 8
    bgt s3, t0, repeat

    # wait if the time has not come
    li  t0, stepTime
    blt s4, t0, repeat

    li  s4, 0 # reset the counter

    # enable one more 7 segment
    sll s5, s5, 1
    sw  s5, (s1)

    # write new value to the system
    slli s2, s2, 4
    add s2, s2, s3
    sw  s2, 4(s1)

    addi s3, s3, 1 # increment 7 Segment value counter

    j   repeat

    # exit main
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp) # LED values
    lw  s4, 20(sp) # stepTime
    lw  s5, 24(sp)
    addi sp, sp, 32

    ret