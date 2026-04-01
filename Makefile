SRC = src/imm_gen.v src/regfile.v src/alu.v src/decoder.v src/memory.v src/cpu.v

RISCV_TEST_DIR = riscv-tests/isa

TESTS = $(basename $(notdir $(wildcard $(RISCV_TEST_DIR)/rv32ui/*.S)))

hex/%.hex:
	riscv64-unknown-elf-objcopy -O verilog $(RISCV_TEST_DIR)/rv32ui-p-$* hex/$*.hex

build-tests: $(addprefix hex/, $(addsuffix .hex, $(TESTS)))

test-%: hex/%.hex sim/sim_riscv_test.out
	vvp sim/sim_riscv_test.out +HEX=hex/$*.hex

sim/sim_riscv_test.out: tb/tb_riscv_test.v $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim_riscv_test.out tb/tb_riscv_test.v $(SRC)

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
