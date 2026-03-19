module memory (
    input clk,
    input mem_read,
    input mem_write,
    input [1:0] mem_size,
    input mem_signed,
    input [31:0] addr,
    input [31:0] wdata,

    output reg [31:0] rdata
);

    reg [7:0] mem [0:16383];

    always @(*) begin
        case (mem_size)
            2'b00: rdata = mem_signed ?
                { {24{mem[addr][7]}}, mem[addr] } :
                { 24'b0, mem[addr] };
            2'b01: rdata = mem_signed ?
                { {16{mem[addr + 1][7]}}, mem[addr + 1], mem[addr] } :
                { 16'b0, mem[addr + 1], mem[addr] };
            2'b10: rdata = { mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr] };
            default: rdata = 32'b0;
        endcase
    end

    always @(posedge clk) begin
        if (mem_write)
            case (mem_size)
                2'b00: begin mem[addr] <= wdata[7:0]; end
                2'b01: begin { mem[addr + 1], mem[addr] } <= wdata[15:0]; end
                2'b10: begin { mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} <= wdata; end
            endcase
    end

endmodule
