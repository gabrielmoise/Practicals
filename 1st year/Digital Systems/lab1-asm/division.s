        .syntax unified
        .global foo

        .text
        .thumb_func

@ works for divisions of numbers < 2^30 - 1
foo:
    movs r2, #0
    movs r3, #1

estimate:
    lsls r3, r3, #1
    lsls r1, r1, #1
    cmp r1, r0
    blt estimate

loop:
    cmp r0, r1
    blt skip
    subs r0, r0, r1
    orrs r2, r2, r3
skip:
    lsrs r1, r1, #1
    lsrs r3, r3, #1
    bne loop

done:
    movs r0, r2
    bx lr
