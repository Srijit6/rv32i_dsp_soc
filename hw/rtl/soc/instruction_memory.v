`timescale 1ns / 1ps

module instruction_memory (
    input  wire        clk,
    input  wire [31:0] addr,
    output wire [31:0] inst
);

    // Memory shrunk to 8 words (32 bytes) for fast physical synthesis
    reg [31:0] rom [0:7];

    // Load the machine code on startup
    initial begin
        // The path must be absolute for OpenLane Docker compatibility
        $readmemh("/home/srijitsengupta/rv32i_dsp_soc/dv/assembly/mac_test.hex", rom);
    end

    // Read logic: Shift right by 2 because address is byte-aligned, but memory is word-aligned
    assign inst = rom[addr[9:2]];

endmodule
