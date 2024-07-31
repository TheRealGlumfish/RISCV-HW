`timescale 1ps/1ps
module mem_tb;

bit          clk;
int          addrA;
int          addrB;
int          dataA_i;
logic [31:0] dataA_o_mock;
logic [31:0] dataA_o_gowin;
logic [31:0] dataB_o_mock;
logic [31:0] dataB_o_gowin;
bit   [2:0]  selA; 
bit          wenA;

localparam SIZE = 32;

// TOOD: Finish the testbench
initial begin
    int i;
    clk = 1'b0;
    wenA = 1'b0;
    #10
    $display("Mock memory initialized to:");
    for(i = 0; i < SIZE*4; i = i + 4)
        $display("%h", {dut1.mem[i+3], dut1.mem[i+2], dut1.mem[i+1], dut1.mem[i]});
    $display("Gowin memory initialized to:");
    for(i = 0; i < SIZE; i = i + 1)
        $display("%h", dut2.mem[i]);
    for(i = 0; i < SIZE*4; i = i + 4)
        assert({dut1.mem[i+3], dut1.mem[i+2], dut1.mem[i+1], dut1.mem[i]} === dut2.mem[i/4]); // === is used to compare x's
    $finish;
end

always
    #5 clk = !clk;

mock_mem #(.SIZE(SIZE)) dut1(
    .clk,
    .addrA,
    .addrB,
    .dataA_o(dataA_o_mock),
    .dataB_o(dataB_o_mock),
    .selA,
    .wenA,
    .dataA_i
);

gowin_mem #(.SIZE(SIZE)) dut2(
    .clk,
    .addrA,
    .addrB,
    .dataA_o(dataA_o_gowin),
    .dataB_o(dataB_o_gowin),
    .selA,
    .wenA,
    .dataA_i
);

endmodule