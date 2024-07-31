.global _start

_start:
    mv t0, zero # 0
    li t1, 2    # 4
    li zero, 5  # 8
    add t2, t0, t1 # 12
    add t2, t1, t1 # 16
    li a0, 1 # 20
    jal a0, func # 24
loop:
    addi a0, a0, 1 # 28
    beq zero, zero, loop # 32
    nop # 36
func:
    li s0, 0xFF # 40
    li s0, 0x00 # 44
    li s0, 0xFE # 48
    jalr zero, a0, 0x00 # ret? # 52
