// RV32I Mock Memory
`timescale 1ps/1ps
module mock_mem#(
    parameter SIZE = 128
)(
    input               clk,
    input        [31:0] addrA, // read port
    input        [31:0] addrB, // read/write port
    output logic [31:0] dataA_o,
    output logic [31:0] dataB_o,
    input        [2:0]  selA, // funct3
    input               wenA,
    input        [31:0] dataA_i
);

logic [7:0] mem [(SIZE*4)-1:0];
logic [31:0] data_o_reg;

initial begin // TODO: Potentially initialize while declaring to prevent sim from complaining
    $readmemh("../tb/test.mem", mem);
end

always_ff@(posedge clk)
    unique case(selA)
        3'b000: dataA_o <= {{24{mem[addrA][7]}}, mem[addrA]}; // lb
        3'b001: dataA_o <= {{16{mem[addrA+1][7]}}, mem[addrA+1], mem[addrA]}; // lh
        3'b010: dataA_o <= {mem[addrA+3], mem[addrA+2], mem[addrA+1], mem[addrA]}; // lw
        3'b100: dataA_o <= {8'b0, 8'b0, 8'b0, mem[addrA]}; // lbu
        3'b101: dataA_o <= {8'b0, 8'b0, mem[addrA+1], mem[addrA]}; // lhu
    endcase
// TODO: Test sign extension works

always_ff@(posedge clk)
    dataB_o <= {mem[addrB+3], mem[addrB+2], mem[addrB+1], mem[addrB]};

always_ff@(posedge clk) begin
    if(wenA)
        unique case(selA)
            3'b000: mem[addrA] <= dataA_i[7:0];
            3'b001: {mem[addrA+1], mem[addrA]} <= dataA_i[15:0];
            3'b010: {mem[addrA+3], mem[addrA+2], mem[addrA+1], mem[addrA]} <= dataA_i;
        endcase
end

endmodule