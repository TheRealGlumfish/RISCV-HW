// RV32I Mock Memory
`timescale 1ps/1ps
module mem(
    input               clk,
    input        [31:0] addr,
    output logic [31:0] data_o,
    input        [2:0]  sel, // funct3
    input               wen,
    input        [31:0] data_i
);

logic [7:0] mem [128:0];
logic [31:0] mem_init[31:0];
logic [31:0] data_o_reg;

initial begin
    int i;
    // $readmemh("../tb/test.mem_32", mem_init);
    $readmemh("../tb/test.mem", mem);
    $display("Memory initialized to:");
    // Convert word addressed memory to byte addressed
    // for(i = 0; i < 32; i = i + 1) begin
        // {mem[i+3], mem[i+2], mem[i+1], mem[i]} = mem_init[i];
    for(i = 0; i < 128; i = i + 4)
        $display("%h", {mem[i+3], mem[i+2], mem[i+1], mem[i]});
    // $display("This is how word memory would look like:");
    // for(i = 0; i < 32; i = i + 1)
    //     $display("%h", mem_init[i]);
end

always_ff
    unique case(sel) // TODO: Ensure this infers combinational logic
        3'b000: data_o = {{24{mem[addr][7]}}, mem[addr]}; // lb
        3'b001: data_o = {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]}; // lh
        3'd010: data_o = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; // lw
        3'b100: data_o = {8'b0, 8'b0, 8'b0, mem[addr]}; // lbu
        3'b101: data_o = {8'b0, 8'b0, mem[addr+1], mem[addr]}; // lhu
    endcase
// TODO: Test sign extension works

always_ff@(posedge clk) begin
    if(wen)
        unique case(sel)
            3'b000: mem[addr] <= data_i[7:0];
            3'b001: {mem[addr+1], mem[addr]} <= data_i[15:0];
            3'b010: {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} <= data_i;
        endcase
end

endmodule