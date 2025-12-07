# memory-mapped I/O addresses
#define GPIO_IN      0x80001400
#define GPIO_OUT     0x80001404
#define GPIO_INOUT   0x80001408

#define PTC2_BASE    0x80001240
#define PTC3_BASE    0x80001280
#define PTC4_BASE    0x800012C0

.globl main

.text
main:
    # enter main
    addi sp, sp, -16
    sw  s0, 0(sp) # base address of GPIO memory-mapped registers
    sw  s2, 4(sp) # base address for B
    sw  s3, 8(sp) # base address for G
    sw  s4, 16(sp) # base address for R
    
    # initialize variables and constants
    li  s0, GPIO_IN
    li  s2, PTC2_BASE
    li  s3, PTC3_BASE
    li  s4, PTC4_BASE

    # initialize GPIO
    li  t1, 0xFFFF      # set direction of GPIOs
    sw  t1, 8(s0)       # GPIO_INOUT = 0xFFFF

    # fix LRC registers to 65 so that it is always 0.5 < (64-[switch value])/65 < 1
    li  t0, 65
    sw  t0, 8(s2)
    sw  t0, 8(s3)
    sw  t0, 8(s4)

    repeat:
        # read switches and extract PWM values for BGR
        lw  t0, (s0)
        srli t0, t0, 16
        andi a2, t0, 0x1f   # extract duty cycle value for B
        srli t0, t0, 5
        andi a3, t0, 0x1f   # extract duty cycle value for G
        srli t0, t0, 5
        andi a4, t0, 0x1f   # extract duty cycle value for R

        # set HRC registers according to the inputs (64-[switch value])
        li  t0, 64
        sub t1, t0, a2
        sw  t1, 4(s2)
        sub t1, t0, a3
        sw  t1, 4(s3)
        sub t1, t0, a4
        sw  t1, 4(s4)

        # reset PTC modules
        li  t0, 0xC0
        sw  t0, 12(s2)
        sw  t0, 12(s3)
        sw  t0, 12(s4)

        # start PTC modules in PWM mode
        li  t0, 0x9
        sw  t0, 12(s2)
        sw  t0, 12(s3)
        sw  t0, 12(s4)

        # delay
        li  t0, 0x2000
        delay:
            add t0, t0, -1
            bge t0, zero, delay

        j   repeat

    # exit main
    lw  s0, 0(sp) # base address of GPIO memory-mapped registers
    lw  s2, 4(sp) # base address for B
    lw  s3, 8(sp) # base address for G
    lw  s4, 16(sp) # base address for R
    addi sp, sp, 16

    ret

.end