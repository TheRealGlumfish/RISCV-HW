`timescale 1ps/1ps
module pio#(
    parameter ADDR_IN = 32'h00000100,
    parameter ADDR_OUT = 32'h00000104
)(
    input               clk,
    input               en,
    input        [31:0] addr,
    input        [31:0] data_i,
    output logic [31:0] data_o = 0,
    input        [31:0] in,
    output logic [31:0] out = 0
);

always_ff@(posedge clk) begin
    data_o <= in; // TOOD: Check for ADDR_IN
    if(addr==ADDR_OUT && en)
        out <= data_i;
end

endmodule