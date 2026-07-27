`timescale 1ns / 1ps

module rv32i_top (
    input  wire        clk,
    input  wire        rst_n,
    
    // Instruction Memory Interface
    input  wire [31:0] inst_in,
    output wire [31:0] inst_addr_out,
    
    // DSP Coprocessor Interface
    input  wire [31:0] dsp_result_in,
    input  wire        dsp_ready_in,
    output wire [31:0] rs1_out,
    output wire [31:0] rs2_out,
    output wire        dsp_valid_out
);

    // --- Core Interconnect Signals ---
    wire [6:0]  opcode;
    wire [4:0]  rs1_addr, rs2_addr, rd_addr;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [31:0] imm_ext;
    wire        is_custom_dsp;

    wire [31:0] reg_rs1_data, reg_rs2_data;
    wire        reg_write_en;
    wire [31:0] reg_write_data;

    wire        branch_en;
    wire [31:0] branch_target;
    wire [31:0] alu_result;

    // 1. Fetch Stage
    fetch u_fetch (
        .clk(clk),
        .rst_n(rst_n),
        .branch_en(branch_en),
        .branch_target(branch_target),
        .pc_out(inst_addr_out)
    );

    // 2. Decode Stage
    decode u_decode (
        .inst(inst_in),
        .opcode(opcode),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .funct3(funct3),
        .funct7(funct7),
        .imm_ext(imm_ext),
        .is_custom_dsp(is_custom_dsp)
    );

    // 3. Register File
    register_file u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(reg_rs1_data),
        .rs2_data(reg_rs2_data),
        .rd_addr(rd_addr),
        .rd_data(reg_write_data),
        .reg_write_en(reg_write_en)
    );

    // 4. Execute Stage (ALU)
    execute u_execute (
        .pc_in(inst_addr_out),
        .rs1_data(reg_rs1_data),
        .rs2_data(reg_rs2_data),
        .imm_ext(imm_ext),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        
        .alu_result(alu_result),
        .branch_en(branch_en),
        .branch_target(branch_target)
    );

    // Route Register data out to DSP Coprocessor
    assign rs1_out       = reg_rs1_data;
    assign rs2_out       = reg_rs2_data;
    assign dsp_valid_out = is_custom_dsp;

    // ==========================================
    // 5. WRITEBACK STAGE
    // ==========================================
    
    // Write Enable Logic: Write to register file if it's an ALU op (R-type or I-type) 
    // OR if it's a DSP operation that has finished computing.
    assign reg_write_en = (opcode == 7'b0110011) || // R-Type
                          (opcode == 7'b0010011) || // I-Type
                          (is_custom_dsp && dsp_ready_in); 

    // Write Data MUX: If the DSP is ready, save the DSP result. Otherwise, save the ALU result.
    assign reg_write_data = (is_custom_dsp) ? dsp_result_in : alu_result;

endmodule
