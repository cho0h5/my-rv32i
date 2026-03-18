SRC = src/imm_gen.v src/regfile.v
TB = tb/tb_regfile.v

sim: $(SRC) $(TB)
	mkdir -p sim
	iverilog -I src -o sim/sim.out $(TB) $(SRC)
	vvp sim/sim.out

check: $(SRC)
	iverilog -I src -o /dev/null $(SRC)

wave:
	gtkwave sim/dump.vcd

clean:
	rm -rf sim
