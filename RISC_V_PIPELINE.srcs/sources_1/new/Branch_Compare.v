`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 07:49:17 PM
// Design Name: 
// Module Name: Branch_Compare
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


module Branch_Compare#(
    parameter DATA_WIDTH = 32
)(
    input wire BrUn,
    input wire [DATA_WIDTH - 1:0] A,
    input wire [DATA_WIDTH - 1:0] B,
    output wire BrLT,
    output wire BrEq
    );
    wire sign_A = A[31];
    wire sign_B = B[31];
    wire A_lt_B_unsigned = (A < B) ? 1 : 0;
    wire BrLT_signed = ((sign_A & ~sign_B) |
                       (~sign_A & ~sign_B & A_lt_B_unsigned) |
                       (sign_A & sign_B & A_lt_B_unsigned)) ? 1 : 0;
    assign BrEq = (A == B) ? 1 : 0;
    assign BrLT = (BrUn) ? A_lt_B_unsigned : BrLT_signed;

endmodule
