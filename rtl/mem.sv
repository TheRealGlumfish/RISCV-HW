// RV32I Mock Memory
`timescale 1ps/1ps
module mem(
    input         clk,
    input  [31:0] addr,
    output [31:0] data_o,
    input  [1:0]  sel,
    input         wen,
    input  [31:0] data_i
);

logic [7:0] mem [31:0];

always_comb
    priority case(sel) // TODO: Ensure this infers combinational logic
        4'd0: data_o = {8'b0, 8'b0, 8'b0, mem[addr]};
        4'd1: data_o = {8'b0, 8'b0, mem[addr+1], mem[addr]};
        4'd2: data_o = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    endcase

always_ff@(posedge clk) begin
    if(wen)
        priority case(sel)
            4'd0: mem[addr] <= data_i[7:0];
            4'd1: {mem[addr+1], mem[addr]} <= data_i[15:0];
            4'd2: {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} <= data_i;
        endcase
end

endmodule