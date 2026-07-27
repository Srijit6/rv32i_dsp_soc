`timescale 1ns / 1ps

module fetch (
    input  wire        clk,
    input  wire        rst_n,
    
    // Control signals from the Execute stage (for branching)
    input  wire        branch_en,
    input  wire [31:0] branch_target,
    
    // Output to Instruction Memory and Decode stage
    output reg  [31:0] pc_out
);

    wire [31:0] next_pc;

    // Next PC logic: Jump to branch_target if branch_en is high, otherwise PC + 4
    assign next_pc = branch_en ? branch_target : (pc_out + 32'd4);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset vector (where the processor starts executing)
            pc_out <= 32'b0;
        end else begin
            pc_out <= next_pc;
        end
    end

endmodule
