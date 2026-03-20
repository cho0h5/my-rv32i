- 2026-03-13 ~ 2026-03-17: Study Verilog (https://hdlbits.01xz.net/)
- 2026-03-18: Try running picorv32
- 2026-03-18 ~ 2026-03-20: Implement rv32i & pass all 42 riscv-tests rv32ui tests

    | Format | Category | Instructions |
    |:------:|----------|-------------|
    | R | Register Arithmetic | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND |
    | I | Jump | JALR |
    | I | Load | LB, LH, LW, LBU, LHU |
    | I | Immediate Arithmetic | ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI |
    | I | System | ECALL, CSRRS, CSRRW |
    | S | Store | SB, SH, SW |
    | U | Upper Immediate | LUI, AUIPC |
    | B | Branch | BEQ, BNE, BLT, BGE, BLTU, BGEU |
    | J | Jump | JAL |

    <details><summary>Test Result</summary>

    ```sh
    ➜  my-rv32i git:(main) make test-all
    mkdir -p sim
    iverilog -I src -o sim/sim_riscv_test.out tb/tb_riscv_test.v src/imm_gen.v src/regfile.v src/alu.v src/decoder.v src/memory.v src/cpu.v
    [PASS] add
    [PASS] addi
    [PASS] and
    [PASS] andi
    [PASS] auipc
    [PASS] beq
    [PASS] bge
    [PASS] bgeu
    [PASS] blt
    [PASS] bltu
    [PASS] bne
    [PASS] fence_i
    [PASS] jal
    [PASS] jalr
    [PASS] lb
    [PASS] lbu
    [PASS] ld_st
    [PASS] lh
    [PASS] lhu
    [PASS] lui
    [PASS] lw
    [PASS] ma_data
    [PASS] or
    [PASS] ori
    [PASS] sb
    [PASS] sh
    [PASS] simple
    [PASS] sll
    [PASS] slli
    [PASS] slt
    [PASS] slti
    [PASS] sltiu
    [PASS] sltu
    [PASS] sra
    [PASS] srai
    [PASS] srl
    [PASS] srli
    [PASS] st_ld
    [PASS] sub
    [PASS] sw
    [PASS] xor
    [PASS] xori

    42 passed, 0 failed
    ```

    </details>

- 2026-03-20: Run C/Rust code on the CPU
