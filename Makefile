SRC = src/imm_gen.v

check: $(SRC)
	iverilog -I src -o /dev/null $(SRC)
