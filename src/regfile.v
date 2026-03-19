module regfile (
    input clk,
    input we,
    input [4:0] rs1, rs2, rd,
    input [31:0] wdata,
    output [31:0] rdata1, rdata2
);

    reg [31:0] regs [1:31];

    integer i;
    initial begin
        for (i = 1; i < 32; i = i + 1) begin
            regs[i] = 32'b0;
        end
    end

    assign rdata1 = rs1 == 5'd0 ? 32'd0 : regs[rs1];
    assign rdata2 = rs2 == 5'd0 ? 32'd0 : regs[rs2];

    always @(posedge clk) begin
        if (we && rd != 5'd0) regs[rd] <= wdata;
    end

endmodule
