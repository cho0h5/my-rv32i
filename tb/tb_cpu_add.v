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
        $readmemh("/tmp/add.hex", cpu0.imem.mem);
        $readmemh("/tmp/add.hex", cpu0.dmem.mem);

        clk = 0; rst = 1;
        @(posedge clk);
        #1;
        rst = 0;

        // repeat(100000) @(posedge clk);
        repeat(2000) @(posedge clk);
        $display("TIMEOUT");
        $display("mem[0x1000] = %h", cpu0.dmem.mem[32'h1000]);
        $finish;
    end

    wire [31:0] tohost = { cpu0.dmem.mem[32'h1003],
        cpu0.dmem.mem[32'h1002],
        cpu0.dmem.mem[32'h1001],
        cpu0.dmem.mem[32'h1000] };

    always @(posedge clk) begin
        $display("PC = %h, INST = %h, GP = %h", pc, cpu0.inst, cpu0.regfile0.regs[3]);

        if (cpu0.dmem.mem_write) begin
            $display(">>> [MEM_WRITE] Addr: %h, Data: %h, Size: %b", 
                     cpu0.dmem.addr, cpu0.dmem.wdata, cpu0.dmem.mem_size);
        end

        if (tohost != 0) begin
            if (tohost == 1) $display("PASS");
            else $display("FAIL: test %0d", tohost >> 1);
            $finish;
        end

        if (cpu0.dmem.mem_write && cpu0.dmem.addr == 32'h1000) begin
            if (cpu0.dmem.wdata == 32'h1) begin
                $display("PASS");
                $finish;
            end else begin
                $display("FAIL: test %0d", cpu0.dmem.wdata >> 1);
                $finish;
            end
        end
    end

endmodule
