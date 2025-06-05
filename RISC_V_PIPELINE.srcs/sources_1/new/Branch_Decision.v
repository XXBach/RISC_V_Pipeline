`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 04:26:26 PM
// Design Name: 
// Module Name: Branch_Decision
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


module Branch_Decision#(
    parameter INSTRUCTION_WIDTH = 32
)(
    input wire is_Br,
    input wire BrEq,
    input wire BrLt,
    input wire [INSTRUCTION_WIDTH - 1:0] instruction,
    output reg PCSel
    );
    wire [6:0]opcode;
    wire [2:0]funct3;
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    always@(*) begin
        if(is_Br) begin
        case(opcode)
            7'b1101111, 7'b1100111: PCSel = 1;
            7'b1100011: begin
                case(funct3)
                    3'b000: PCSel = (BrEq && !BrLt) ? 1:0; //BEQ
                    3'b001: PCSel = (!BrEq) ? 1:0; //BNE
                    3'b100, 3'b110: PCSel = (!BrEq && BrLt) ? 1:0; //BLT
                    3'b101, 3'b111: PCSel = (!BrLt) ? 1:0; //BGE
                    default: PCSel = 0;
                endcase
            end
            default: PCSel = 0;
        endcase
        end
        else PCSel = 0;
    end
endmodule
