`timescale 1ns/1ps
`include "defines.v"
module tb_memory;
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [1:0] mem_size;
    reg mem_signed;
    reg [31:0] addr;
    reg [31:0] wdata;

    wire [31:0] rdata;

    memory uut (
        .clk(clk), .mem_read(mem_read), .mem_write(mem_write),
        .mem_size(mem_size), .mem_signed(mem_signed),
        .addr(addr), .wdata(wdata), .rdata(rdata),
        .iaddr(32'b0), .inst()
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_memory);

        clk = 0; mem_read = 1; mem_write = 0; mem_size = 2'b10; mem_signed = 1'b0;

        @(posedge clk); mem_write = 1; addr = 32'h42; wdata = 32'h12345678;
        #1;
        mem_write = 0;

        $display("mem[0x42] = %0x (expect 12345678)", rdata);

        addr = 32'h43;
        #1;
        $display("mem[0x43] = %0d (expect x)", rdata);

        @(posedge clk); mem_write = 1; wdata = 32'habcdef01;
        #1
        $display("mem[0x43] = %0x (expect abcdef01)", rdata);

        @(posedge clk); mem_write = 1; mem_size = 2'b00; mem_signed = 1'b1;
        addr = 32'h44; wdata = 32'habcdefff;
        #1
        $display("mem[0x44] = %0d (expect -1)", $signed(rdata));


        @(posedge clk); mem_write = 1; mem_size = 2'b01; mem_signed = 1'b0;
        addr = 32'h45; wdata = 32'habcdefff;
        #1
        $display("mem[0x44] = %0x (expect efff)", rdata);

        $finish;
    end

endmodule
