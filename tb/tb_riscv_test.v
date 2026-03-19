`timescale 1ns/1ps
`include "defines.v"

module tb_riscv_test;
    reg clk = 0, rst = 1;
    wire [31:0] pc;

    cpu uut (.clk(clk), .rst(rst), .pc(pc));
    always #5 clk = ~clk;

    reg [255:0] hex_file;
    initial begin
        if (!$value$plusargs("HEX=%s", hex_file)) begin
            $display("Usage: +HEX=<hexfile>");
            $finish;
        end
        $readmemh(hex_file, uut.imem.mem);
        #15 rst = 0;
    end

    reg [31:0] tohost_addr;
    initial begin
        tohost_addr = 32'h1000;
        if ($value$plusargs("TOHOST=%h", tohost_addr)) ;
    end

    reg [31:0] tohost;
    always @(*) begin
        tohost = {uut.dmem.mem[tohost_addr+3], uut.dmem.mem[tohost_addr+2],
                  uut.dmem.mem[tohost_addr+1], uut.dmem.mem[tohost_addr]};
    end

    initial begin
        repeat(100000) @(posedge clk);
        $display("TIMEOUT");
        $finish;
    end

    always @(posedge clk) begin
        if (!rst && ^tohost !== 1'bx) begin
            if (tohost == 32'h1) begin $display("PASS"); $finish; end
            else if (tohost != 32'h0) begin $display("FAIL: test %0d", tohost >> 1); $finish; end
        end
    end
endmodule
