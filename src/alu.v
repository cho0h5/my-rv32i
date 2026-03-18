`include "defines.v"

module alu (
    input [31:0] a, b,
    input [3:0] op,
    output reg [31:0] result
);

    always @(*) begin
        case (op)
            `ALU_ADD: result = a + b;
            `ALU_SLT: result = $signed(a) < $signed(b) ? 32'd1 : 32'd0;
            `ALU_SLTU: result = a < b ? 32'd1 : 32'd0;
            `ALU_AND: result = a & b;
            `ALU_OR: result = a | b;
            `ALU_XOR: result = a ^ b;
            `ALU_SLL: result = a << b[4:0];
            `ALU_SRL: result = a >> b[4:0];
            `ALU_SRA: result = $signed(a) >>> b[4:0];
            `ALU_SUB: result = a - b;
        endcase
    end

endmodule
