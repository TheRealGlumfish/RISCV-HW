`timescale 1ps/1ps
module mem_tb;

bit          clk;
int          addr;
logic [31:0] data_o;
bit   [1:0]  sel; 
bit          wen;
int          data_i;

// TOOD: Finish the testbench
initial begin
    clk = 1'b0;
    addr = 0;
    sel = 2'd2;
    wen = 1'b0;
    data_i = 0;
    #10;
    wen = 1'b1;
    #10;
    data_i = 32'b11110101;
    addr = 4;
    #10
    addr = 8;
end

always
    #5 clk = !clk;

mem dut(
    .clk,
    .addr,
    .data_o,
    .sel,
    .wen,
    .data_i
);

endmodule