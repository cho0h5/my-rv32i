module cpu (
    input clk,
    input rst,
    output [31:0] pc
);

    wire [31:0] inst;
    wire [2:0] inst_type;
    wire [3:0] alu_op;
    wire alu_src, reg_write, mem_read, mem_write;
    wire [1:0] mem_size;
    wire mem_signed, branch, jump;
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd = inst[11:7];
    wire [2:0] funct3 = inst[14:12];

    wire [31:0] rdata1, rdata2;

    wire [31:0] imm;

    reg [31:0] pc_reg;
    reg [31:0] pc_next;

    wire [31:0] regfile_wdata, alu_src_val, alu_result, dmem_rdata;

    memory imem (
        .clk(clk), .mem_read(1'b1), .mem_write(1'b0),
        .mem_size(2'b10), .mem_signed(1'b0),
        .addr(pc), .wdata(32'b0), .rdata(inst)
    );

    decoder decoder0 (
        .inst(inst),
        .inst_type(inst_type), .alu_op(alu_op),
        .alu_src(alu_src), .reg_write(reg_write), .mem_read(mem_read), .mem_write(mem_write),
        .mem_size(mem_size), .mem_signed(mem_signed),
        .branch(branch), .jump(jump)
    );

    imm_gen imm_gen0 (
        .inst(inst), .type(inst_type), .imm(imm)
    );

    assign regfile_wdata = mem_read ? dmem_rdata : alu_result;

    regfile regfile0 (
        .clk(clk), .we(reg_write),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wdata(regfile_wdata), .rdata1(rdata1), .rdata2(rdata2)
    );

    assign alu_src_val = alu_src == `ALU_SRC_RS2 ? rdata2 : imm;

    alu alu0 (
        .a(rdata1), .b(alu_src_val),
        .op(alu_op),
        .result(alu_result)
    );

    memory dmem (
        .clk(clk), .mem_read(1'b1), .mem_write(mem_write),
        .mem_size(mem_size), .mem_signed(mem_signed),
        .addr(alu_result), .wdata(rdata2), .rdata(dmem_rdata)
    );

    assign pc = pc_reg;

    always @(*) begin
        if (jump && inst[6:0] == `OP_JALR) pc_next = alu_result;
        else if (jump) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BEQ && alu_result == 32'b0) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BNE && alu_result != 32'b0) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BLT && alu_result == 32'b1) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BGE && alu_result == 32'b0) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BLTU && alu_result == 32'b1) pc_next = pc + imm;
        else if (branch && funct3 == `FUNCT3_BGEU && alu_result == 32'b0) pc_next = pc + imm;
        else pc_next = pc + 4;
    end

    always @(posedge clk) begin
        if (rst) pc_reg <= 32'b0;
        else pc_reg <= pc_next;
    end

endmodule
