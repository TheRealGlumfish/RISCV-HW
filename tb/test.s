.global _start

_start:
    mv t0, zero
    li t1, 2
    li zero, 5
    add t2, t0, t1
    add t2, t1, t1
loop:
    nop
    beq zero, zero, loop
