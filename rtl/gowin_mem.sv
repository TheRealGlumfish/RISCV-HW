// RV32I Memory Optimized for Gowin Synthesis
`timescale 1ps/1ps
module gowin_mem#(
    parameter SIZE = 128
)(
    input               clk,
    input        [31:0] addrA, // read port
    input        [31:0] addrB, // read/write port
    output logic [31:0] dataA_o,
    output logic [31:0] dataB_o,
    input        [2:0]  selA, // funct3
    input               wenA,
    input        [31:0] dataA_i
);

logic [31:0] mem [SIZE-1:0]; // 128 words

initial
    $readmemh("../tb/test.mem_32", mem);

always_ff@(posedge clk) begin
    dataA_o <= mem[addrA[31:2]];
    if(wenA)
        mem[addrA] <= dataA_i;
end

always_ff@(posedge clk) begin
    dataB_o <= mem[addrB[31:2]]; // check if byte or word address and byte enable
end

endmodule