`timescale 1ps/1ps
module top_tb;
   bit clk;
   bit rst_n; 
   logic in1;
   logic in2;
   logic out1;
   logic out2;

initial begin
    clk = 1'b0;
    rst_n = 1'b1; // TODO: Enable reset
    #1000
    $finish;
end

always
    #5 clk = !clk;

top dut(
    .clk,
    .rst_n,
    .in1,
    .in2,
    .out1,
    .out2
);

endmodule