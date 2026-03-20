`define R_TYPE 3'd0
`define I_TYPE 3'd1
`define S_TYPE 3'd2
`define U_TYPE 3'd3
`define B_TYPE 3'd4
`define J_TYPE 3'd5

`define ALU_ADD 4'd0
`define ALU_SLT 4'd1
`define ALU_SLTU 4'd2
`define ALU_AND 4'd3
`define ALU_OR 4'd4
`define ALU_XOR 4'd5
`define ALU_SLL 4'd6
`define ALU_SRL 4'd7
`define ALU_SRA 4'd8
`define ALU_SUB 4'd9

`define OP_LOAD 7'b0000011
`define OP_STORE 7'b0100011
`define OP_BRANCH 7'b1100011
`define OP_JALR 7'b1100111
`define OP_JAL 7'b1101111
`define OP_IMM 7'b0010011
`define OP_OP 7'b0110011
`define OP_SYSTEM 7'b1110011
`define OP_AUIPC 7'b0010111
`define OP_LUI 7'b0110111

`define FUNCT3_BEQ 3'b000
`define FUNCT3_BNE 3'b001
`define FUNCT3_BLT 3'b100
`define FUNCT3_BGE 3'b101
`define FUNCT3_BLTU 3'b110
`define FUNCT3_BGEU 3'b111

`define FUNCT3_LB 3'b000
`define FUNCT3_LH 3'b001
`define FUNCT3_LW 3'b010
`define FUNCT3_LBU 3'b100
`define FUNCT3_LHU 3'b101

`define FUNCT3_SB 3'b000
`define FUNCT3_SH 3'b001
`define FUNCT3_SW 3'b010

`define FUNCT3_ADDI 3'b000
`define FUNCT3_SLTI 3'b010
`define FUNCT3_SLTIU 3'b011
`define FUNCT3_XORI 3'b100
`define FUNCT3_ORI 3'b110
`define FUNCT3_ANDI 3'b111
`define FUNCT3_SLLI 3'b001
`define FUNCT3_SRLI 3'b101
`define FUNCT3_SRAI 3'b101

`define FUNCT3_ADD 3'b000
`define FUNCT3_SUB 3'b000
`define FUNCT3_SLL 3'b001
`define FUNCT3_SLT 3'b010
`define FUNCT3_SLTU 3'b011
`define FUNCT3_XOR 3'b100
`define FUNCT3_SRL 3'b101
`define FUNCT3_SRA 3'b101
`define FUNCT3_OR 3'b110
`define FUNCT3_AND 3'b111

`define FUNCT3_CSRRW 3'b001
`define FUNCT3_CSRRS 3'b010
`define CSR_MTVEC  12'h305
`define CSR_MCAUSE 12'h342

`define ALU_SRC_RS2 1'b0
`define ALU_SRC_IMM 1'b1

`define ALU_A_SRC_RS1 2'd0
`define ALU_A_SRC_PC 2'd1
`define ALU_A_SRC_ZERO 2'd2
