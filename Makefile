SRC = src/imm_gen.v src/regfile.v src/alu.v

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
