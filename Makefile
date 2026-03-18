SRC = src/imm_gen.v src/regfile.v

check: $(SRC)
	iverilog -I src -o /dev/null $(SRC)
