`timescale 1ns / 1ps

module dsp_coprocessor (
    input  wire        clk,
    input  wire        rst_n,
    
    // Core Interface
    input  wire [31:0] rs1_in,
    input  wire [31:0] rs2_in,
    input  wire        valid_in,
    
    output wire [31:0] result_out,
    output wire        ready_out
);

    wire clear_flag;
    wire [31:0] mac_result;

    // Custom Control Logic:
    // If the core sends rs2 as exactly 0, we treat it as a "Clear Accumulator" command.
    assign clear_flag = (rs2_in == 32'b0);

    // Instantiate the MAC unit
    mac_unit u_mac (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .clear_acc(clear_flag),
        .a_in(rs1_in),
        .b_in(rs2_in),
        .acc_out(mac_result)
    );

    // The result is wired directly back to the core
    assign result_out = mac_result;
    
    // For this simple design, the MAC completes in 1 cycle, so ready is tied to valid
    assign ready_out  = valid_in;

endmodule
