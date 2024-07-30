.global _start

_start:
    mv t0, zero # 0
    li t1, 2    # 4
    li zero, 5  # 8
    add t2, t0, t1 # 12
    add t2, t1, t1 # 16
    li a0, 0 # 20
loop:
    addi a0, a0, 1 # 24
    beq zero, zero, loop # 28
    .word 0xFFFFFFFF # 32
