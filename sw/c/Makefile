# This file is for dev

all:
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -O2 -T link.ld startup.S main.c -o main.elf
	riscv64-unknown-elf-objdump -h main.elf
	riscv64-unknown-elf-objdump -d main.elf
	riscv64-unknown-elf-objcopy -O verilog main.elf main.hex
	vvp ../../sim/sim_riscv_test.out +HEX=main.hex +TOHOST=1000
