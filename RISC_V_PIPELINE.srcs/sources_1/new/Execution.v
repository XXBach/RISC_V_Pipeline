`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 08:28:20 PM
// Design Name: 
// Module Name: Execution
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


module Execution #(
    parameter DATA_WIDTH = 32,
    parameter PC_WIDTH = 16,
    parameter OPERATION_NUMS = 16
)(
    input wire ASel,
    input wire BSel,
    input wire [$clog2(OPERATION_NUMS) - 1:0] ALU_Sel,
    input wire [PC_WIDTH - 1:0] PC,
    input wire [DATA_WIDTH - 1:0] rs1,
    input wire [DATA_WIDTH - 1:0] rs2,
    input wire [DATA_WIDTH - 1:0] imm,
    output wire [DATA_WIDTH - 1:0] Result
    );
    wire [DATA_WIDTH - 1:0] A_Factor;
    wire [DATA_WIDTH - 1:0] B_Factor;
    Mux2_to_1#(
        .DATA_WIDTH(DATA_WIDTH)
    )A_mux(
        .Sel(ASel),
        .A(rs1),
        .B(PC),
        .C(A_Factor)
    );
    Mux2_to_1#(
        .DATA_WIDTH(DATA_WIDTH)
    )B_mux(
        .Sel(BSel),
        .A(rs2),
        .B(imm),
        .C(B_Factor)
    );
    ALU#(
        .DATA_WIDTH(DATA_WIDTH),
        .OPERATION_NUMS(OPERATION_NUMS)
    )ALUnit(
        .ALU_Sel(ALU_Sel),
        .A_Factor(A_Factor),
        .B_Factor(B_Factor),
        .Result(Result)
    );
endmodule
