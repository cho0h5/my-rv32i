# This file is for dev
# rustup target add riscv32i-unknown-none-elf

all:
	rustc --target riscv32i-unknown-none-elf --edition 2021 -C opt-level=2 --emit=obj main.rs -o main.o -C debug-assertions=no
	riscv64-unknown-elf-objdump -h main.o
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T ../c/link.ld ../c/startup.S main.o -o main.elf
	riscv64-unknown-elf-objdump -d main.elf
	riscv64-unknown-elf-objcopy -O verilog main.elf main.hex
	vvp ../../sim/sim_riscv_test.out +HEX=main.hex +TOHOST=1000
