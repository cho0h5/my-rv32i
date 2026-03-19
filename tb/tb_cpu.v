`timescale 1ns/1ps
`include "defines.v"
module tb_cpu;
    reg clk, rst;
    wire [31:0] pc;

    cpu cpu0 (
        .clk(clk), .rst(rst), .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_cpu);
        $readmemh("hex/test.hex", cpu0.imem.mem);

        clk = 0; rst = 1;
        @(posedge clk);
        #1;
        rst = 0;

        repeat(10) @(posedge clk);
        $display("pc = %0h", pc);

        $display("x1 = %0d (expect 5)", cpu0.regfile0.regs[1]);
        $display("x2 = %0d (expect 3)", cpu0.regfile0.regs[2]);
        $display("x3 = %0d (expect 8)", cpu0.regfile0.regs[3]);

        $finish;
    end
endmodule
