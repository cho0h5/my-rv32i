SRC = src/imm_gen.v src/regfile.v src/alu.v src/decoder.v src/memory.v src/cpu.v

RISCV_TEST_DIR = riscv-tests/isa

UI_TESTS = $(basename $(notdir $(wildcard $(RISCV_TEST_DIR)/rv32ui/*.S)))
MI_TESTS = $(basename $(notdir $(wildcard $(RISCV_TEST_DIR)/rv32mi/*.S)))

sim/sim_riscv_test.out: tb/tb_riscv_test.v $(SRC)
	mkdir -p sim
	iverilog -I src -o sim/sim_riscv_test.out tb/tb_riscv_test.v $(SRC)

riscv-tests/.built:
	cd riscv-tests && ./configure --with-xlen=32 && $(MAKE) isa
	touch riscv-tests/.built

hex/ui/%.hex: | riscv-tests/.built
	mkdir -p hex/ui
	riscv64-unknown-elf-objcopy -O verilog --change-addresses -0x80000000 $(RISCV_TEST_DIR)/rv32ui-p-$* hex/ui/$*.hex

hex/mi/%.hex: | riscv-tests/.built
	mkdir -p hex/mi
	riscv64-unknown-elf-objcopy -O verilog --change-addresses -0x80000000 $(RISCV_TEST_DIR)/rv32mi-p-$* hex/mi/$*.hex

build-ui-tests: $(addprefix hex/ui/, $(addsuffix .hex, $(UI_TESTS)))
build-mi-tests: $(addprefix hex/mi/, $(addsuffix .hex, $(MI_TESTS)))
build-tests: build-ui-tests build-mi-tests

define run-tests
	@pass=0; fail=0; \
	for t in $(1); do \
		tohost=$$([ "$$t" = "ld_st" ] && echo 2000 || echo 1000); \
		result=$$(vvp sim/sim_riscv_test.out +HEX=$(2)/$$t.hex +TOHOST=$$tohost 2>&1); \
		if echo "$$result" | grep -q "^PASS"; then \
			printf "[PASS] %s\n" $$t; pass=$$((pass+1)); \
		else \
			printf "[FAIL] %s: %s\n" $$t "$$result"; fail=$$((fail+1)); \
		fi; \
	done; \
	echo ""; \
	printf "%d passed, %d failed\n" $$pass $$fail
endef

test-ui: build-ui-tests sim/sim_riscv_test.out
	$(call run-tests,$(UI_TESTS),hex/ui)

test-mi: build-mi-tests sim/sim_riscv_test.out
	$(call run-tests,$(MI_TESTS),hex/mi)

test-all: build-tests sim/sim_riscv_test.out
	@echo "=== rv32ui ==="; \
	$(MAKE) --no-print-directory test-ui; \
	echo ""; \
	echo "=== rv32mi ==="; \
	$(MAKE) --no-print-directory test-mi

wave:
	gtkwave sim/dump.vcd

clean:
	rm -rf sim hex
