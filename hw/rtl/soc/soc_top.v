`timescale 1ns / 1ps

module soc_top (
    input  wire        clk,
    input  wire        rst_n,
    
    // This output prevents Yosys from deleting your core during synthesis
    output wire [31:0] monitor_out
);

    // ==========================================
    // 1. Interconnect Wires
    // ==========================================
    wire [31:0] inst_addr_wire;
    wire [31:0] inst_wire;
    wire [31:0] rs1_wire;
    wire [31:0] rs2_wire;
    wire [31:0] dsp_result_wire;
    wire        dsp_ready_wire;

    // ==========================================
    // 2. Instruction Memory
    // ==========================================
    instruction_memory imem (
        .clk(clk),
        .addr(inst_addr_wire),
        .inst(inst_wire)
    );

    // ==========================================
    // 3. Main RISC-V Core
    // ==========================================
    rv32i_top core (
        .clk(clk),
        .rst_n(rst_n),
        .inst_in(inst_wire),
        .inst_addr_out(inst_addr_wire),
        .dsp_result_in(dsp_result_wire),
        .dsp_ready_in(dsp_ready_wire),
        .rs1_out(rs1_wire),
        .rs2_out(rs2_wire)
    );

    // ==========================================
    // 4. DSP Coprocessor
    // ==========================================
    dsp_coprocessor dsp (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_in(rs1_wire),
        .rs2_in(rs2_wire),
        .valid_in(1'b1), // Tied high to prevent a floating input
        .result_out(dsp_result_wire),
        .ready_out(dsp_ready_wire)
    );

    // ==========================================
    // 5. Physical Synthesis Anchor
    // ==========================================
    // XORing active signals ensures Yosys keeps both modules
    assign monitor_out = inst_addr_wire ^ rs1_wire ^ dsp_result_wire;

endmodule
