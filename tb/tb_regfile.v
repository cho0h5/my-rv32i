`timescale 1ns/1ps
module tb_regfile;
    reg clk, we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wdata;
    wire [31:0] rdata1, rdata2;

    regfile uut (
        .clk(clk), .we(we),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wdata(wdata),
        .rdata1(rdata1), .rdata2(rdata2)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_regfile);

        clk = 0; we = 0;
        @(posedge clk); we = 1; rd = 5'd1; wdata = 32'd42;
        #1;
        we = 0;

        rs1 = 5'd1;
        #1;
        $display("x1 = %0d (expect 42)", rdata1);

        rs1 = 5'd0;
        #1;
        $display("x0 = %0d (expect 0)", rdata1);

        @(posedge clk); we = 1; rd = 5'd5; wdata = 32'd24;
        #1;
        we = 0;

        rs2 = 5'd5;
        #1;
        $display("x5 = %0d (expect 24)", rdata2);

        $finish;
    end
endmodule
