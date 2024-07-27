// RV32I Register File
`timescale 1ps/1ps
module regfile(
    input               clk,
    input               wen,
    input        [4:0]  regA_sel,
    input        [4:0]  regB_sel,
    input        [4:0]  regW_sel,
    input        [31:0] regW_i,
    output logic [31:0] regA_o,
    output logic [31:0] regB_o
);

logic [31:0] registers[31:0];

// TODO: Examine write/read order and check synthesis results
always_comb begin
    if(regA_sel == 5'b0)
        regA_o = 0;
    else
        regA_o = registers[regA_sel];
    if(regB_sel == 5'b0)
        regB_o = 0;
    else
        regB_o = registers[regB_sel];
end

always_ff @(posedge clk) begin
    if(wen) // TODO: Potentially make zero register unwritable, check synthesis results
        registers[regW_sel] <= regW_i;
end

endmodule
