.globl main

.equ Seg_ADDR, 0x80001038

main:
    li  t1, Seg_ADDR

    # write ello
    li  t0, 0xb0f1f181;
    sw  t0, (t1)

    # write h
    li  t0, 0xffffffc8
    sw  t0, 4(t1)

    ret