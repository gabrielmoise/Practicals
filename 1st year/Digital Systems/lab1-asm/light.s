        .syntax unified
        .global foo

        .text
        .thumb_func

        .equ GPIO_OUT, 0x50000504

foo:
    ldr r0, =0x2000
    ldr r1, =GPIO_OUT
    str r0, [r1]
    b .
