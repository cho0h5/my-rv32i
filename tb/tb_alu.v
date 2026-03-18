`timescale 1ns/1ps
`include "defines.v"
module tb_alu;
    reg [31:0] a, b;
    reg [3:0] op;
    wire [31:0] result;

    alu uut (
        .a(a), .b(b),
        .op(op),
        .result(result)
    );

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, tb_alu);

        a = 32'd11;
        b = 32'd3;
        op = `ALU_ADD;
        #1;
        $display("result = %0d (expect 14)", result);

        op = `ALU_SLL;
        #1;
        $display("result = %0d (expect 88)", result);

        a = 32'd3;
        b = 32'd11;
        op = `ALU_SUB;
        #1;
        $display("result = %0d (expect -8)", $signed(result));

        $finish;
    end
endmodule
