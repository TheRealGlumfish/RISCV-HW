`timescale 1ps/1ps
module alu_tb;
int       A;
int       B;
bit [3:0] ctrl;
integer   res;

initial begin
    A = 31;
    B = 32;
    ctrl = 4'b0000; // add
    #10 assert(res == (31 + 32));
    A = 5;
    B = -2;
    ctrl = 4'b0000; // add
    #10 assert(res == (5 - 2));
    A = 4;
    B = 2;
    ctrl = 4'b1000; // sub
    #10 assert(res == (4 - 2));
    A = 4;
    B = -2;
    ctrl = 4'b1000; // sub
    #10 assert(res == 6);
end

alu dut(
    .A,
    .B,
    .ctrl,
    .res
);

endmodule