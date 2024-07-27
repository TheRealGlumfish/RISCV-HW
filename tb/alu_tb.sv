`timescale 1ps/1ps
module alu_tb;
int          A;
int          B;
bit   [3:0]  ctrl;
logic [31:0] res;
logic        zero;

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
    A = 3;
    B = 1;
    ctrl = 4'b0010; // slt
    #10 assert(res == 0);
    A = 1;
    B = 3;
    ctrl = 4'b0010; // slt
    #10 assert(res == 1);
    A = 1;
    B = -3;
    ctrl = 4'b0010; // slt
    #10 assert(res == 0);
    A = -3;
    B = -5;
    ctrl = 4'b0010; // slt
    #10 assert(res == 0);
    A = -5;
    B = -3;
    ctrl = 4'b0010; // slt
    #10 assert(res == 1);
    A = {2'b11, {30{1'b0}}};
    B = {2'b00, {30{1'b0}}};
    ctrl = 4'b0011; // sltu
    #10 assert(res == 0);
    A = {2'b00, {30{1'b0}}};
    B = {2'b11, {30{1'b0}}};
    ctrl = 4'b0011; // sltu
    #10 assert(res == 1);
    // TODO: Add additional tests for left/right shifts
end

alu dut(
    .A,
    .B,
    .ctrl,
    .res
);

endmodule