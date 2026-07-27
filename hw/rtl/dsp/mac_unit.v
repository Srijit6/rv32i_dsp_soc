`timescale 1ns / 1ps

module mac_unit (
    input  wire        clk,
    input  wire        rst_n,
    
    // Control
    input  wire        valid_in, 
    input  wire        clear_acc, 
    
    // Data
    input  wire [31:0] a_in,
    input  wire [31:0] b_in,
    
    // Output (Changed to wire to instantly route the answer to the core)
    output wire [31:0] acc_out
);

    reg [31:0] acc_reg; // Internal accumulator register
    
    // Combinational math happens instantly
    wire [31:0] mult_result = a_in * b_in;
    wire [31:0] next_acc    = clear_acc ? mult_result : (acc_reg + mult_result);

    // Route the immediate answer directly to the output port
    assign acc_out = next_acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg <= 32'b0;
        end else if (valid_in) begin
            // Save the value on the clock edge for the next cycle
            acc_reg <= next_acc;
        end
    end

endmodule
