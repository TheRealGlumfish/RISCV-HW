// RV32I Arithmetic Logic Unit (ALU)
`timescale 1ps/1ps
module alu(
    input        [31:0] A,
    input        [31:0] B,
    input        [3:0]  ctrl,
    output logic [31:0] res, // TODO: Register the output depending on synthesis results
    output              zero // TOOD: Verify whether this is the most efficient/perfomant way to do this
);
// TODO: Potentially pack funct3 and funct7 into a unified control signal
// TOOD: Add support for multiply/divide instructions
logic signed [31:0] A_signed;
logic signed [31:0] B_signed;

assign A_signed = A;
assign B_signed = B;

always_comb
    unique case(ctrl)
        // R-type / I-type
        4'b0000: // add / addi
            res = A_signed + B_signed;
        4'b1000: // sub / subi
            res = A_signed - B_signed;
        4'b0001: // sll / slli
            res = A << B[4:0];
        4'b0010: // slt / slti
            res = A_signed < B_signed;
        4'b0011: // sltu / sltiu
            res = A < B;
        4'b0100: // xor / xori
            res = A^B;
        4'b0101: // srl / srli
            res = A >> B[4:0];
        4'b1101: // sra / srai
            res = A >>> B[4:0];
        4'b0110: // or / ori
            res = A | B;
        4'b0111: // and / andi
            res = A & B;
        4'b1111: // lui TODO: Potentially change
            res = B;
    endcase

// TODO: See if this logic can be improved, by additional hardware or different ways of checking
assign zero = res == 0;

endmodule