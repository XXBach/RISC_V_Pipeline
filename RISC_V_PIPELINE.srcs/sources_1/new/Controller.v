`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 04:01:38 PM
// Design Name: 
// Module Name: Controller
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


module Controller#(
    parameter INSTRUCTION_WIDTH = 32,
    parameter OPERATION_NUMS = 16,
    parameter IMM_MODE_NUMS = 8
)(
    //Global input
    input wire clk,
    input wire reset,
    input wire start,
    
    //Input Datapath
    input wire [INSTRUCTION_WIDTH - 1:0] instruction,
    input wire BrEq,
    input wire BrLt,
    
    //Control Output
    output wire PCSel,
    output wire [$clog2(IMM_MODE_NUMS) - 1:0] ImmSel,
    output wire RegWEn,
    output wire BrUn,
    output wire ASel,
    output wire BSel,
    output wire [$clog2(OPERATION_NUMS) - 1:0] ALUSel,
    output wire MemRW,
    output wire [1:0] WBSel
    );
    wire is_Br;
    reg is_ALU_ff;
    wire is_ALU;
    reg [INSTRUCTION_WIDTH - 1:0] instruction_ALU;
    Main_Controller#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH)
    )Main_CTRL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .instruction(instruction),
        .ImmSel(ImmSel),
        .RegWEn(RegWEn),
        .BrUn(BrUn),
        .is_Br(is_Br),
        .ASel(ASel),
        .BSel(BSel),
        .is_ALU(is_ALU),
        .MemRW(MemRW),
        .WBSel(WBSel)
    );
    Branch_Decision#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH)
    )BD(
        .is_Br(is_Br),
        .BrEq(BrEq),
        .BrLt(BrLt),
        .instruction(instruction),
        .PCSel(PCSel)
    );
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            is_ALU_ff <= 0;
            instruction_ALU <= 0;
        end
        else begin
            is_ALU_ff <= is_ALU;
            instruction_ALU <= instruction;
        end
    end
    ALU_SEL#(
        .OPERATION_NUMS(OPERATION_NUMS),
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH)
    )ALU_SELECT(
        .is_ALU(is_ALU_ff),
        .instruction(instruction_ALU),
        .ALU_Sel(ALUSel)
    );  
endmodule
