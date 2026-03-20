module cpu (
    input clk,
    input rst,
    output [31:0] pc
);

    wire [31:0] inst;
    wire [2:0] inst_type;
    wire [3:0] alu_op;
    wire [1:0] alu_a_src;
    wire alu_src, reg_write, mem_read, mem_write;
    wire [1:0] mem_size;
    wire mem_signed, branch, jump, ecall, csr_read;
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd = inst[11:7];
    wire [2:0] funct3 = inst[14:12];

    wire [31:0] rdata1, rdata2;

    wire [31:0] imm;

    reg [31:0] pc_reg;
    reg [31:0] pc_next;
    reg [31:0] mcause;

    wire [31:0] regfile_wdata, alu_a_val, alu_src_val, alu_result, dmem_rdata;
    wire [31:0] csr_rdata = (inst[31:20] == `CSR_MCAUSE) ? mcause : 32'b0;

    memory mem0 (
        .clk(clk), .mem_read(1'b1), .mem_write(mem_write),
        .mem_size(mem_size), .mem_signed(mem_signed),
        .addr(alu_result), .wdata(rdata2), .rdata(dmem_rdata),
        .iaddr(pc), .inst(inst)
    );

    decoder decoder0 (
        .inst(inst),
        .inst_type(inst_type), .alu_op(alu_op),
        .alu_a_src(alu_a_src),
        .alu_src(alu_src), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write),
        .mem_size(mem_size), .mem_signed(mem_signed),
        .branch(branch), .jump(jump), .ecall(ecall), .csr_read(csr_read)
    );

    imm_gen imm_gen0 (
        .inst(inst), .type(inst_type), .imm(imm)
    );

    assign regfile_wdata = jump ? (pc + 4) : (csr_read ? csr_rdata : (mem_read ? dmem_rdata : alu_result));

    regfile regfile0 (
        .clk(clk), .we(reg_write),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wdata(regfile_wdata), .rdata1(rdata1), .rdata2(rdata2)
    );

    assign alu_a_val = (alu_a_src == `ALU_A_SRC_PC) ? pc :
                       (alu_a_src == `ALU_A_SRC_ZERO) ? 32'b0 : rdata1;
    assign alu_src_val = alu_src == `ALU_SRC_RS2 ? rdata2 : imm;

    alu alu0 (
        .a(alu_a_val), .b(alu_src_val),
        .op(alu_op),
        .result(alu_result)
    );


    assign pc = pc_reg;

    always @(*) begin
        if (ecall) pc_next = 32'h00000004;
        else if (jump && inst[6:0] == `OP_JALR) pc_next = alu_result;
        else if (jump) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BEQ && alu_result == 32'b0) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BNE && alu_result != 32'b0) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BLT && alu_result == 32'h1) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BGE && alu_result == 32'b0) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BLTU && alu_result == 32'h1) pc_next = pc + $signed(imm);
        else if (branch && funct3 == `FUNCT3_BGEU && alu_result == 32'b0) pc_next = pc + $signed(imm);
        else pc_next = pc + 4;
    end

    always @(posedge clk) begin
        if (rst) begin
            pc_reg <= 32'b0;
            mcause <= 32'b0;
        end else begin
            pc_reg <= pc_next;
            if (ecall) mcause <= 32'd11;
            if (csr_read) mcause <= mcause | rdata1;
        end
    end

endmodule
