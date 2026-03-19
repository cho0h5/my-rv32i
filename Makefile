SRC = src/imm_gen.v src/regfile.v src/alu.v src/decoder.v src/memory.v src/cpu.v

sim-add: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_cpu_add.v $(SRC)
	vvp sim/sim.out

sim-cpu2: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_cpu2.v $(SRC)
	vvp sim/sim.out

sim-cpu: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_cpu.v $(SRC)
	vvp sim/sim.out

sim-memory: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_memory.v $(SRC)
	vvp sim/sim.out

sim-regfile: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_regfile.v $(SRC)
	vvp sim/sim.out

sim-alu: $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim.out tb/tb_alu.v $(SRC)
	vvp sim/sim.out

check: $(SRC)
	iverilog -I src -o /dev/null $(SRC)

wave:
	gtkwave sim/dump.vcd

clean:
	rm -rf sim
