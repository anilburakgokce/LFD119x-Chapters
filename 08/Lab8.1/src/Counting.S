.globl main

.equ SevSeg_ADDR, 0x80001038
.equ PTC_ADDR,    0x80001200

# digits for SevSeg from 0 to 9
.data
decoded_digits: .byte 0x81,0xcf,0x92,0x86,0xcc,0xa4,0xa0,0x8f,0x80,0x8c

.text

# input a0: number to print on seven segment
# no output
write_number:

    # initialize addresses and variables
    li  a1, 0   # decimal digit index to be processed
    li  a2, 10  # decimal base
    li  a3, SevSeg_ADDR
    la  a4, decoded_digits

loop1:
    rem t0, a0, a2 # get decimal digit

    # read decoded digit
    add t1, a4, t0
    lb  a5, (t1) 

    # write the decoded digit to the correct address
    add t0, a3, a1
    sb  a5, (t0)

    addi a1, a1, 1 # increment decimal digit index

    # break when the seven segment limit is reached
    addi t0, a1, -8
    bge t0, zero, end_write_number    

    div a0, a0, a2 # update number
    j   loop1
    
end_write_number:
    ret

main:
    addi sp, sp, -16
    sw  s0, 0(sp) # PTC base address
    sw  s1, 4(sp) # current number

    # initialize variables
    li  s0, PTC_ADDR
    li  s1, 9

    # write the first number to Seven Segment
    mv  a0, s1
    call write_number

    # initialize and begin the PTC counter
    li  t0, 0x20
    sw  t0, 8(s0)
    li  t0, 0xC0
    sw  t0, 12(s0)
    li  t0, 0x21
    sw  t0, 12(s0)

poll_ctr:
    # read INT bit to see if the count is finished
    lw  t0, 12(s0)
    andi t1, t0, 0x40
    
    beqz t1, poll_ctr # if the counter has not fired yet, go back to wait

    # restart the timer
    li  t0, 0xC0
    sw  t0, 12(s0)
    li  t0, 0x21
    sw  t0, 12(s0)

    addi s1, s1, 1 # increment the number

    # write new number to seven segment
    mv  a0, s1
    call write_number

    j   poll_ctr

    # exit main
    lw  s0, 0(sp) # PTC base address
    lw  s1, 4(sp) # current number
    addi sp, sp, 16

    ret
.end