`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 02:41:56 PM
// Design Name: 
// Module Name: ALU_SEL
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_SEL#(
    parameter OPERATION_NUMS = 16,
    parameter INSTRUCTION_WIDTH = 32
)(
    input wire is_ALU,
    input wire [INSTRUCTION_WIDTH - 1:0] instruction,
    output reg [$clog2(OPERATION_NUMS) - 1:0] ALU_Sel
    );
    wire [6:0]opcode;
    wire [2:0]funct3;
    wire [6:0]funct7;
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];
    always@(*) begin
        if(is_ALU) begin
            case(opcode)
                7'b0110011: begin
                    case(funct3)
                        3'b000: begin // ADD / SUB
                            if(funct7 == 7'b0100000) ALU_Sel = 4'b0001;
                            else ALU_Sel = 4'b0000;
                        end
                        3'b001: ALU_Sel = 4'b0100; //SLL
                        3'b010: ALU_Sel = 4'b0010; //SLT
                        3'b011: ALU_Sel = 4'b0011; //SLTU
                        3'b100: ALU_Sel = 4'b1001; //XOR
                        3'b101: begin // SRL / SRA
                            if(funct7 == 7'b0100000) ALU_Sel = 4'b0110;
                            else ALU_Sel = 4'b0101;
                        end
                        3'b110: ALU_Sel = 4'b1000; // OR
                        3'b111: ALU_Sel = 4'b0111; // AND
                        default: ALU_Sel = 4'b0000;
                    endcase
                end
                7'b0010011: begin
                    case(funct3)
                        3'b000: ALU_Sel = 4'b0000; //ADDI
                        3'b001: ALU_Sel = 4'b0100; //SLLI
                        3'b010: ALU_Sel = 4'b0010; //SLTI
                        3'b011: ALU_Sel = 4'b0011; //SLTIU
                        3'b100: ALU_Sel = 4'b1001; //XORI
                        3'b101: begin // SRLI / SRAI
                            if(funct7 == 7'b0100000) ALU_Sel = 4'b0110;
                            else ALU_Sel = 4'b0101;
                        end
                        3'b110: ALU_Sel = 4'b1000; // ORI
                        3'b111: ALU_Sel = 4'b0111; // ANDI
                        default: ALU_Sel = 4'b0000;
                    endcase
                end
                7'b0110111: ALU_Sel = 4'b0111;
                7'b0010111, 7'b1101111, 7'b1100111, 7'b0100011, 7'b0000011: ALU_Sel = 4'b0000;
                default: ALU_Sel = 4'b0000;
            endcase
        end
        else ALU_Sel = 0;
    end
endmodule
