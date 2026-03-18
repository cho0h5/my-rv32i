`include "defines.v"

module imm_gen (
    input [31:0] inst,
    input [2:0] type,
    output reg [31:0] imm
);

    always @(*) begin
        case (type)
            `I_TYPE: imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
            `S_TYPE: imm = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7] };
            `U_TYPE: imm = { inst[31], inst[30:20], inst[19:12], {12{1'b0}} };
            `B_TYPE: imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
            `J_TYPE: imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
        endcase
    end

endmodule
