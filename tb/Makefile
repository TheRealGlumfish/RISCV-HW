.PHONY: clean

clean:
	rm *.mem *.o *.elf

%.mem: %.s
	riscv64-linux-gnu-as -R -march=rv32im -mabi=ilp32 $< -o $@.o
	riscv64-linux-gnu-ld -melf32lriscv_ilp32 -nostdlib -Ttext 0x000000 $@.o -o $@.elf
	riscv64-linux-gnu-objcopy -O verilog $@.elf $@
	riscv64-linux-gnu-objcopy -O verilog --verilog-data-width=4 $@.elf $@_32
