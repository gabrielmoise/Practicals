        .syntax unified
        .global foo

        .text
        .thumb_func

foo:
    movs r2, #0

loop:
    lsrs r1, r1, #1
    bcc skip
    adds r2, r2, r0
skip:
    lsls r0, r0, #1
    cmp r1, #0
    bne loop

done:
    movs r0, r2
    bx lr
