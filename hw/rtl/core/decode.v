`timescale 1ns / 1ps

module decode (
    input  wire [31:0] inst,
    
    // Decoded fields
    output wire  [6:0] opcode,
    output wire  [4:0] rs1_addr,
    output wire  [4:0] rs2_addr,
    output wire  [4:0] rd_addr,
    output wire  [2:0] funct3,
    output wire  [6:0] funct7,
    
    // Sign-extended Immediate (I-Type for now)
    output wire [31:0] imm_ext,
    
    // Custom DSP Flag
    output wire        is_custom_dsp
);

    // RISC-V Opcode mapping
    assign opcode   = inst[6:0];
    assign rd_addr  = inst[11:7];
    assign funct3   = inst[14:12];
    assign rs1_addr = inst[19:15];
    assign rs2_addr = inst[24:20];
    assign funct7   = inst[31:25];

    // Basic I-Type sign extension (12-bit to 32-bit)
    assign imm_ext  = {{20{inst[31]}}, inst[31:20]};

    // Flag for our custom hardware accelerator (Opcode: CUSTOM-0)
    assign is_custom_dsp = (opcode == 7'b0001011);

endmodule
