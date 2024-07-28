`timescale 1ps/1ps
module top(
    input clk,
    input rst
);

logic        mem_wen;
logic [2:0]  mem_mode;
logic [31:0] mem_addr;
logic [31:0] inst_addr;
logic [31:0] mem_data_o;
logic [31:0] mem_data_i; 
logic        mem_sel;

logic        reg_wen;
logic [4:0]  regA_sel;
logic [4:0]  regB_sel;
logic [4:0]  regW_sel;
logic [31:0] regW_i;
logic [31:0] regA_o;
logic [31:0] regB_o;

logic [31:0] alu_B;
logic [3:0]  alu_ctrl;
logic [31:0] alu_res;
logic        alu_zero;

logic [31:0] imm;
logic        imm_sel;
logic        addr_sel;

ctrl main_ctrl(
    .clk,
    .rst,
    .mem_wen,
    .mem_mode,
    .mem_addr(inst_addr),
    .mem_data(mem_data_o),
    .mem_sel,
    .reg_wen,
    .regA_sel,
    .regB_sel,
    .regW_sel,
    .alu_ctrl,
    .zero(alu_zero),
    .imm,
    .imm_sel,
    .addr_sel
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

assign regW_i = mem_sel ? mem_data_o : alu_res;
assign alu_B = imm_sel ? imm : regB_o;

alu main_alu(
    .A(regA_o),
    .B(alu_B),
    .ctrl(alu_ctrl),
    .res(alu_res),
    .zero(alu_zero)
);

assign mem_addr = addr_sel ? alu_res : inst_addr;

mem main_mem(
    .clk,
    .addr(mem_addr),
    .data_o(mem_data_o),
    .sel(mem_mode),
    .wen(mem_wen),
    .data_i(mem_data_i)
);

endmodule