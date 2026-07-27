`timescale 1ns / 1ps

module execute (
    input  wire [31:0] pc_in,
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    input  wire [31:0] imm_ext,
    input  wire  [6:0] opcode,
    input  wire  [2:0] funct3,
    input  wire  [6:0] funct7,
    
    output reg  [31:0] alu_result,
    output reg         branch_en,
    output wire [31:0] branch_target
);

    wire [31:0] alu_in2;

    // Operand 2 MUX: R-Type uses rs2_data, I-Type/Memory uses imm_ext
    // 7'b0110011 is R-Type, 7'b1100011 is B-Type (Branches)
    assign alu_in2 = (opcode == 7'b0110011 || opcode == 7'b1100011) ? rs2_data : imm_ext;

    // Branch Target Adder (PC + Immediate)
    assign branch_target = pc_in + imm_ext;

    // Main ALU Logic
    always @(*) begin
        // Default assignments to prevent latches
        alu_result = 32'b0;
        branch_en  = 1'b0;
        
        case (opcode)
            7'b0110011, 7'b0010011: begin // R-Type and I-Type (Arithmetic)
                case (funct3)
                    3'b000: begin
                        // Distinguish ADD vs SUB using funct7 for R-Type
                        if (opcode == 7'b0110011 && funct7 == 7'b0100000)
                            alu_result = rs1_data - alu_in2;
                        else
                            alu_result = rs1_data + alu_in2;
                    end
                    3'b111: alu_result = rs1_data & alu_in2; // AND
                    3'b110: alu_result = rs1_data | alu_in2; // OR
                    3'b100: alu_result = rs1_data ^ alu_in2; // XOR
                    default: alu_result = 32'b0;
                endcase
            end
            
            7'b1100011: begin // B-Type (Branches)
                case (funct3)
                    3'b000: branch_en = (rs1_data == rs2_data); // BEQ (Branch if Equal)
                    3'b001: branch_en = (rs1_data != rs2_data); // BNE (Branch if Not Equal)
                    default: branch_en = 1'b0;
                endcase
            end
        endcase
    end

endmodule
