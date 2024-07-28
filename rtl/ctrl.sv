// RV32I Main Control Unit
`timescale 1ps/1ps
module ctrl(
    input               clk,
    input               rst,
    output logic        mem_wen,
    output logic [2:0]  mem_mode,
    output       [31:0] mem_addr, // TODO: Assume async mem for now
    input        [31:0] mem_data,
    output logic        mem_sel,
    output logic        reg_wen,
    output       [4:0]  regA_sel,
    output       [4:0]  regB_sel,
    output       [4:0]  regW_sel,
    output logic [3:0]  alu_ctrl,
    input               zero,
    output logic [31:0] imm,
    output logic        imm_sel,
    output logic        addr_sel
);

typedef enum logic [6:0] { 
    RTYPE=7'h33,
    LOAD=7'h03,
    ITYPE=7'h13,
    AUIPC=7'h17, // TOOD: Rename
    LUI=7'h37,
    STORE=7'h23,
    BTYPE=7'h63,
    JAL=7'h6f,
    JALR=7'h67
} opcode_t;

opcode_t     opcode;
logic [6:0]  funct7;
logic [2:0]  funct3;
logic [31:0] pc;

logic [31:0] inst;
assign inst = mem_data;
assign mem_addr = pc;

// TODO: Ensure this works properly
assign opcode = opcode_t'(inst[6:0]);
assign funct3 = inst[14:12];
assign funct7 = inst[31:25];

assign regA_sel = inst[19:15];
assign regB_sel = inst[24:20];
assign regW_sel = inst[11:7];
// assign alu_ctrl = (opcode == RTYPE || opcode == ITYPE) ? {funct7[5], funct3} : 'x;
always_comb // ALU control logic
    unique case(opcode)
        RTYPE: alu_ctrl = {funct7[5], funct3};
        ITYPE: alu_ctrl = {funct7[5], funct3};
        BTYPE: unique case(funct3)
            3'b000: // beq
                alu_ctrl = 4'b1000; // sub
            3'b001: // bne
                alu_ctrl = 4'b1000; // sub
            3'b100: // blt 
                alu_ctrl = 4'b0010; // slt
            3'b101: // bge
                alu_ctrl = 4'b0010; // slt
            3'b110: // bltu
                alu_ctrl = 4'b0011; // sltu
            3'b111: // bgeu
                alu_ctrl = 4'b0011; // sltu
        endcase
        LOAD: alu_ctrl = 4'b0000; // add
        STORE: alu_ctrl = 4'b0000; // add
        // BTYPE:
        // AUIPC:
        // LUI:
        // JAL:
        // JALR:
    endcase

always_comb // Sign extension logic
    unique case(opcode)
        RTYPE: imm = 'x; // TODO: Change, this is bad
        ITYPE: imm = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
        LOAD:  imm = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
        STORE: imm = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
        BTYPE: imm = {{21{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
        AUIPC: imm = {inst[31], inst[30:20], inst[19:12], 12'b0};
        LUI:   imm = {inst[31:12], 12'b0};
        JAL:   imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
        JALR:  imm = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
    endcase

// typedef enum {
//     EXEC,
//     MEM_WRITE 
// } cpu_state_t;

// cpu_state_t state;
initial
    pc = 0;

always_ff@(posedge clk) begin
    if(rst) begin
        pc <= 0;
        // state <= EXEC;
    end
    else begin
        unique case(opcode)
            RTYPE:
                pc <= pc + 4;
            ITYPE:
                pc <= pc + 4;
            LOAD:
                pc <= pc + 4; // TODO: Add state management to storing or just add a second port to the ram
            STORE:
                pc <= pc + 4;
            BTYPE: unique case(funct3)
                3'b000: // beq
                    if(zero)
                        pc <= pc + imm;
                    else
                        pc <= pc + 4;
                3'b001: // bne
                    if(!zero)
                        pc <= pc + imm;
                    else
                        pc <= pc + 4;
                3'b100: // blt 
                    if(!zero)
                        pc <= pc + imm;
                    else
                        pc <= pc + 4;
                3'b101: // bge
                    if(zero)
                        pc <= pc + imm;
                    else
                        pc <= pc + 4;
                3'b110: // bltu
                    if(!zero)
                        pc <= pc + imm;
                    else
                        pc <= pc + 4;
                3'b111: // bgeu
                    if(zero)
                        pc <= pc + imm;
            endcase
        endcase
    end
end

always_comb begin
    imm_sel = 1'b0;
    reg_wen = 1'b0;
    mem_wen = 1'b0;
    mem_mode = 3'b010; // TODO: Add the right code
    mem_sel = 1'b0;
    addr_sel = 1'b0;
    unique case(opcode)
        RTYPE: begin
            reg_wen = 1'b1;
        end 
        ITYPE: begin
            imm_sel = 1'b1;
            reg_wen = 1'b1;
        end
        // LOAD: begin
        //     reg_wen = 1'b1;
        //     imm_sel = 1'b1;
        //     mem_mode = funct3;
        //     mem_sel = 1'b1;
        //     addr_sel = 1'b1;
        // end
        STORE: begin
            reg_wen = 1'b0;
            addr_sel = 1'b1;
        end
        BTYPE: begin
            reg_wen = 1'b0;
        end
    endcase
end



endmodule