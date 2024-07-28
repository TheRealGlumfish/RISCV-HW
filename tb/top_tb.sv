`timescale 1ps/1ps
module top_tb;
   bit clk;
   bit rst; 

initial begin
    clk = 1'b0;
    rst = 1'b0; // TODO: Enable reset
    #200
    $finish;
end

always
    #5 clk = !clk;

top dut(
    .clk,
    .rst
);

endmodule