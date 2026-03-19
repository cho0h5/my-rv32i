`include "defines.v"

module imm_gen (
    input [31:0] inst,
    input [2:0] type,
    output reg [31:0] imm
);

    always @(*) begin
        case (type)
            `I_TYPE: imm = { {20{inst[31]}}, inst[31:20] };
            `S_TYPE: imm = { {20{inst[31]}}, inst[31:25], inst[11:7] };
            `B_TYPE: imm = { {19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
            `U_TYPE: imm = { inst[31:12], 12'b0 };
            `J_TYPE: imm = { {11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0 };
            default: imm = 32'b0;
        endcase
    end

endmodule
