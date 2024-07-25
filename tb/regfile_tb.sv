`timescale 1ps/1ps
module regfile_tb;

bit          clk;
bit          wen;
bit   [4:0]  regA_sel;
bit   [4:0]  regB_sel;
bit   [4:0]  regW_sel;
bit   [31:0] regW_i;
logic [31:0] regA_o;
logic [31:0] regB_o;

int i;
int reg_exp [31:0];

// TOOD: Switch to more complicated timed testing using SV assertions to ensure speciifc timing constraints
initial begin
    clk = 1'b0;
    wen = 1'b0;
    regA_sel = 5'b0;
    regB_sel = 5'b0;
    regW_sel = 5'b0;
    #10 assert(regA_o == 0 && regB_o == 0);
    // Initializes an array of random numbers, leaving the first element empty
    reg_exp[0] = 0;
    for(i = 1; i < 32; i = i + 1)
        reg_exp[i] = $random;
    wen = 1'b1;
    for(i = 0; i < 32; i = i + 1) begin
        regW_sel = i;
        regW_i = reg_exp[i];
        #10;
    end
    wen = 1'b0;
    // Check if write happened properly through both ports
    for(i = 0; i < 32; i = i + 1) begin
        regA_sel = i;
        regB_sel = i;
        #1 assert(regA_o == reg_exp[i]) else $display("Actual: %h, Expected: %h at i=%d", regA_o, reg_exp[i], i);
        #0 assert(regB_o == reg_exp[i]) else $display("Actual: %h, Expected: %h at i=%d", regB_o, reg_exp[i], i);
        #9;
    end
    // Check if ports work independently
    for(i = 0; i < 32; i = i + 1) begin
        regA_sel = 31 - i;
        regB_sel = i;
        #1 assert(regA_o == reg_exp[31 - i]) else $display("Actual: %h, Expected: %h at i=%d", regA_o, reg_exp[31 - i], 31 - i);
        #0 assert(regB_o == reg_exp[i]) else $display("Actual: %h, Expected: %h at i=%d", regB_o, reg_exp[i], i);
        #9;
    end
    $finish;
end

always
    #5 clk = !clk;

regfile dut(
    .clk,
    .wen,
    .regA_sel,
    .regB_sel,
    .regW_sel,
    .regW_i,
    .regA_o,
    .regB_o
);

endmodule