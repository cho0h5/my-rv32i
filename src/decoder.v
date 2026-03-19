module decoder (
    input [31:0] inst,

    output reg [2:0] inst_type,
    output reg [3:0] alu_op,
    output reg alu_src,
    output reg [1:0] alu_a_src,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg [1:0] mem_size,
    output reg mem_signed,
    output reg branch,
    output reg jump,
    output reg ecall,
    output reg csr_read
);

    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];
    wire [6:0] funct7 = inst[31:25];

    always @(*) begin
        inst_type = `I_TYPE;
        alu_op = `ALU_ADD;
        alu_a_src = `ALU_A_SRC_RS1;
        alu_src = `ALU_SRC_RS2;
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_size = 2'b0;
        mem_signed = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        ecall = 1'b0;
        csr_read = 1'b0;

        case (opcode)
            `OP_LOAD: begin
                inst_type = `I_TYPE;
                alu_op = `ALU_ADD;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b1;
                mem_write = 1'b0;
                case (funct3)
                    `FUNCT3_LB: begin mem_size = 2'd0; mem_signed = 1'b1; end
                    `FUNCT3_LH: begin mem_size = 2'd1; mem_signed = 1'b1; end
                    `FUNCT3_LW: begin mem_size = 2'd2; mem_signed = 1'b1; end
                    `FUNCT3_LBU: begin mem_size = 2'd0; mem_signed = 1'b0; end
                    `FUNCT3_LHU: begin mem_size = 2'd1; mem_signed = 1'b0; end
                endcase
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_STORE: begin
                inst_type = `S_TYPE;
                alu_op = `ALU_ADD;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b1;
                case (funct3)
                    `FUNCT3_SB: mem_size = 2'd0;
                    `FUNCT3_SH: mem_size = 2'd1;
                    `FUNCT3_SW: mem_size = 2'd2;
                endcase
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_BRANCH: begin
                inst_type = `B_TYPE;
                case (funct3)
                    `FUNCT3_BEQ: alu_op = `ALU_SUB;
                    `FUNCT3_BNE: alu_op = `ALU_SUB;
                    `FUNCT3_BLT: alu_op = `ALU_SLT;
                    `FUNCT3_BGE: alu_op = `ALU_SLT;
                    `FUNCT3_BLTU: alu_op = `ALU_SLTU;
                    `FUNCT3_BGEU: alu_op = `ALU_SLTU;
                endcase
                alu_src = `ALU_SRC_RS2;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b1;
                jump = 1'b0;
            end

            `OP_JALR: begin
                inst_type = `I_TYPE;
                alu_op = `ALU_ADD;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b1;
            end

            `OP_JAL: begin
                inst_type = `J_TYPE;
                alu_op = `ALU_ADD;
                alu_a_src = `ALU_A_SRC_PC;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b1;
            end

            `OP_IMM: begin
                inst_type = `I_TYPE;
                case (funct3)
                    `FUNCT3_ADDI: alu_op = `ALU_ADD;
                    `FUNCT3_SLTI: alu_op = `ALU_SLT;
                    `FUNCT3_SLTIU: alu_op = `ALU_SLTU;
                    `FUNCT3_XORI: alu_op = `ALU_XOR;
                    `FUNCT3_ORI: alu_op = `ALU_OR;
                    `FUNCT3_ANDI: alu_op = `ALU_AND;
                    `FUNCT3_SLLI: alu_op = `ALU_SLL;
                    `FUNCT3_SRLI: alu_op = inst[30] ? `ALU_SRA : `ALU_SRL;
                endcase
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_OP: begin
                inst_type = `R_TYPE;
                case (funct3)
                    `FUNCT3_ADD: alu_op = inst[30] ? `ALU_SUB : `ALU_ADD;
                    `FUNCT3_SLL: alu_op = `ALU_SLL;
                    `FUNCT3_SLT: alu_op = `ALU_SLT;
                    `FUNCT3_SLTU: alu_op = `ALU_SLTU;
                    `FUNCT3_XOR: alu_op = `ALU_XOR;
                    `FUNCT3_SRL: alu_op = inst[30] ? `ALU_SRA : `ALU_SRL;
                    `FUNCT3_OR: alu_op = `ALU_OR;
                    `FUNCT3_AND: alu_op = `ALU_AND;
                endcase
                alu_src = `ALU_SRC_RS2;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_AUIPC: begin
                inst_type = `U_TYPE;
                alu_op = `ALU_ADD;
                alu_a_src = `ALU_A_SRC_PC;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_LUI: begin
                inst_type = `U_TYPE;
                alu_op = `ALU_ADD;
                alu_a_src = `ALU_A_SRC_ZERO;
                alu_src = `ALU_SRC_IMM;
                reg_write = 1'b1;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
            end

            `OP_SYSTEM: begin
                if (inst[31:7] == 25'b0) begin
                    ecall = 1'b1;
                end else if (funct3 == `FUNCT3_CSRRS) begin
                    csr_read = 1'b1;
                    reg_write = 1'b1;
                end
            end
        endcase
    end

endmodule
