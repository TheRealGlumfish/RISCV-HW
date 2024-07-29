`timescale 1ps/1ps
module top(
    input clk,
    input rst
);

logic        mem_wen;
logic [2:0]  mem_mode;
logic [31:0] inst_addr;
logic [31:0] inst_data;
logic [31:0] mem_data;
logic        mem_sel;

logic        reg_wen;
logic [4:0]  regA_sel;
logic [4:0]  regB_sel;
logic [4:0]  regW_sel;
logic [31:0] regW_i;
logic [31:0] regA_o;
logic [31:0] regB_o;

logic [31:0] alu_A;
logic [31:0] alu_B;
logic [3:0]  alu_ctrl;
logic [31:0] alu_res;
logic        alu_zero;

logic [31:0] imm;
logic        imm_sel;
logic        pc_sel;

ctrl main_ctrl(
    .clk,
    .rst,
    .mem_wen,
    .mem_mode,
    .mem_addr(inst_addr),
    .mem_data(inst_data),
    .mem_sel,
    .reg_wen,
    .regA_sel,
    .regB_sel,
    .regW_sel,
    .alu_ctrl,
    .alu_zero,
    .regA(regA_o),
    .imm,
    .imm_sel,
    .pc_sel
);

regfile main_regfile(
    .clk,
    .wen(reg_wen),
    .regA_sel,
    .regB_sel,
    .regW_sel,
    .regW_i,
    .regA_o,
    .regB_o
);

assign regW_i = mem_sel ? mem_data : alu_res;
assign alu_B = imm_sel ? imm : regB_o;
assign alu_A = pc_sel ? inst_addr : regA_o;

alu main_alu(
    .A(alu_A),
    .B(alu_B),
    .ctrl(alu_ctrl),
    .res(alu_res),
    .zero(alu_zero)
);

mem main_mem(
    .clk,
    .addrA(alu_res),
    .addrB(inst_addr),
    .dataA_o(mem_data),
    .dataB_o(inst_data),
    .selA(mem_mode),
    .wenA(mem_wen),
    .dataA_i(regB_o)
);

endmodule