`timescale 1ns / 1ps

module register_file (
    input  wire        clk,
    input  wire        rst_n,
    
    // Read ports (Asynchronous/Combinational read)
    input  wire  [4:0] rs1_addr,
    input  wire  [4:0] rs2_addr,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,
    
    // Write port (Synchronous write)
    input  wire  [4:0] rd_addr,
    input  wire [31:0] rd_data,
    input  wire        reg_write_en
);

    reg [31:0] registers [0:31];
    integer i;

    // Register 0 is always 0. Others read actual memory.
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 1; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write_en && rd_addr != 5'b0) begin
            // Never write to x0
            registers[rd_addr] <= rd_data;
        end
    end

endmodule
