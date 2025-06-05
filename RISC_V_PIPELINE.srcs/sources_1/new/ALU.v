`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 08:04:23 PM
// Design Name: 
// Module Name: ALU
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


module ALU#(
    parameter DATA_WIDTH = 32,
    parameter OPERATION_NUMS = 16   
)(
    input wire [$clog2(OPERATION_NUMS) - 1:0] ALU_Sel,
    input wire [DATA_WIDTH - 1:0] A_Factor,
    input wire [DATA_WIDTH - 1:0] B_Factor,
    output reg [DATA_WIDTH - 1:0] Result
    );
    always@(*) begin
        case(ALU_Sel)
            4'b0000: Result = A_Factor + B_Factor; //Add
            4'b0001: Result = A_Factor - B_Factor; //Sub
            4'b0010: Result = (A_Factor < B_Factor) ? 1 : 0; // SLT
            4'b0011: Result = ($unsigned(A_Factor) < $unsigned(B_Factor)) ? 1:0; // SLT unsigned
            4'b0100: Result = A_Factor << (B_Factor); //Logical Left Shift by B bit
            4'b0101: Result = A_Factor >> (B_Factor); //Logical Right Shift by B bit
            4'b0110: Result = A_Factor >>> (B_Factor); // Arithmetic Right Shift
            4'b0111: Result = A_Factor & B_Factor; // A and B bitwise
            4'b1000: Result = A_Factor | (B_Factor); // A or B bitwise
            4'b1001: Result = A_Factor ^ (B_Factor); // A xor B bitwise
            default: Result = 0;
        endcase
    end
endmodule
