// memory-mapped I/O addresses
# GPIO_IN   = 0x80001400
# GPIO_OUT  = 0x80001404
# GPIO_INOUT = 0x80001408

.globl main

.equ slowStepTime, 0x400
.equ fastStepTime, 0x100
.equ left, 0
.equ right, 1

# inputs:
# a0: current LED values
# a1: direction (0 or 1)
# output:
# a0: next LED values
nextLEDvalues:

    li  t0, left
    beq a1, t0, directionLeft

    # handle right direction
    srli a0, a0, 1
    # handle cases 0, 0x8000, 0xC000, 0xE000, 0xF000
    li t0, 1
    slli t0, 15
    or a0, a0, t0
    j nextLEDvalues

directionLeft:
    slli a0, a0, 1
    andi a0, a0, 0xFFFF
    
    # handle cases 0,1,3,or 7
    li t0, 0xF
    bge a0, t0 nextLEDvaluesEnd
    addi a0, a0, 1

nextLEDvaluesEnd:
    ret


main:
    # enter main
    addi sp, sp, -32
    sw  ra, 0(sp)
    sw  s0, 4(sp) # address of GPIO registers
    sw  s1, 8(sp) # counter
    sw  s2, 12(sp) # direction
    sw  s3, 16(sp) # LED values
    sw  s4, 20(sp) # stepTime


    li  s0, 0x80001400   # base address of GPIO memory-mapped registers
    li  t1, 0xFFFF       # set direction of GPIOs
                        # upper half = switches (inputs)  (=0)
                        # lower half = outputs (LEDs)     (=1)
    sw  t1, 8(s0)        # GPIO_INOUT = 0xFFFF

    li  s1, 0 # set counter to 0

repeat:
    # read switches 0 and 1
    lw  t1, 0(s0)
    srli t1, t1, 16
    andi t1, t1, 3

    # branch according to the switches
    beqz t1, switches_00
    addi t1, t1, -1
    beqz t1, switches_01
    addi t1, t1, -1
    beqz t1, switches_10
    addi t1, t1, -1
    beqz t1, switches_11
switches_00:
    li  s4, slowStepTime
    li  s2, left # set direction to left
    j   switches_check_end
switches_01:
    li  s4, fastStepTime
    li  s2, left # set direction to left
    j   switches_check_end
switches_10:
    li  s4, slowStepTime
    li  s2, right # set direction to right
    j   switches_check_end
switches_11:
    li  s4, fastStepTime
    li  s2, right # set direction to right
switches_check_end:

    addi s1, s1, 1 # increment counter

    blt s1, s4, repeat # if not time, go back to beginning

    li  s1, 0 # reset the counter

    # call nextLEDvalues
    mov a0, s3
    mov a1, s2
    call nextLEDvalues
    mov s3, a0
    
    sw  s3, 4(s0)      # write value to LEDs
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