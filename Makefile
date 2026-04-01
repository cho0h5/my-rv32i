SRC = src/imm_gen.v src/regfile.v src/alu.v src/decoder.v src/memory.v src/cpu.v

RISCV_TEST_DIR = riscv-tests/isa

TESTS = $(basename $(notdir $(wildcard $(RISCV_TEST_DIR)/rv32ui/*.S)))

sim/sim_riscv_test.out: tb/tb_riscv_test.v $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim_riscv_test.out tb/tb_riscv_test.v $(SRC)

hex/%.hex:
	riscv64-unknown-elf-objcopy -O verilog $(RISCV_TEST_DIR)/rv32ui-p-$* hex/$*.hex

build-tests: $(addprefix hex/, $(addsuffix .hex, $(TESTS)))

test-all: build-tests sim/sim_riscv_test.out
	@pass=0; fail=0; \
	for t in $(TESTS); do \
		tohost=1000; \
		if [ "$$t" = "ld_st" ]; then tohost=2000; fi; \
		result=$$(vvp sim/sim_riscv_test.out +HEX=hex/$$t.hex +TOHOST=$$tohost 2>&1); \
		if echo "$$result" | grep -q "^PASS"; then \
			printf "[PASS] %s\n" $$t; pass=$$((pass+1)); \
		else \
			printf "[FAIL] %s: %s\n" $$t "$$result"; fail=$$((fail+1)); \
		fi; \
	done; \
	echo ""; \
	printf "%d passed, %d failed\n" $$pass $$fail

wave:
	gtkwave sim/dump.vcd

clean:
	rm -rf sim
