`timescale 1ps/1ps
module top(
    input clk,
    input rst_n,
    input in1,
    input in2,
    output out1,
    output out2
);

logic [31:0] bus_addr;
logic [31:0] bus_data_in; // Data to CPU
logic [31:0] bus_data_out; // Data to bus
logic        bus_en;
logic        mem_wen;
logic [2:0]  mem_mode;
logic [31:0] inst_addr;
logic [31:0] inst_data;
logic [31:0] mem_data;
logic        mem_sel;
logic [31:0] pio_data_out; // Data to bus

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
logic [31:0] pc;
logic        pc_sel;

logic [31:0] pio_in;
logic [31:0] pio_out;

ctrl main_ctrl(
    .clk,
    .rst(!rst_n),
    .mem_en(bus_en),
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
    .pc_old(pc),
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

assign regW_i = mem_sel ? bus_data_in : alu_res;
assign alu_B = imm_sel ? imm : regB_o;
assign alu_A = pc_sel ? pc : regA_o;

alu main_alu(
    .A(alu_A),
    .B(alu_B),
    .ctrl(alu_ctrl),
    .res(alu_res),
    .zero(alu_zero)
);

localparam ADDR_PERIPH = 32'h00000100;
localparam ADDR_IN = 32'h00000100;
localparam ADDR_OUT = 32'h00000104;

assign bus_addr = alu_res;
assign bus_data_out = regB_o;

always_comb begin
    if(bus_addr < ADDR_PERIPH)
        bus_data_in = mem_data;    
    else
        bus_data_in = pio_data_out;
end

mock_mem sim_mem(
   .clk,
   .addrA(bus_addr),
   .addrB(inst_addr),
   .dataA_o(mem_data),
   .dataB_o(inst_data),
   .selA(mem_mode),
   .wenA(mem_wen),
   .dataA_i(bus_data_out)
);

//  gowin_mem syn_mem(
//      .clk,
//      .addrA(bus_addr),
//      .addrB(inst_addr),
//      .dataA_o(mem_data),
//      .dataB_o(inst_data),
//      .selA(mem_mode),
//      .wenA(mem_wen),
//      .dataA_i(bus_data_out)
// );

pio #(.ADDR_IN(ADDR_IN), .ADDR_OUT(ADDR_OUT))pio1(
    .clk,
    .en(bus_en),
    .addr(bus_addr),
    .data_i(bus_data_out),
    .data_o(pio_data_out),
    .in(pio_in),
    .out(pio_out)
);

assign pio_in = {30'b0, in2, in1};
assign {out2, out1} = pio_out;

endmodule