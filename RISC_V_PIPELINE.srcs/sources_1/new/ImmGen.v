`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2025 08:32:19 PM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen#(
    parameter INSTRUCTION_WIDTH = 32,
    parameter IMM_MODE_NUMS = 8
)(
    input wire [INSTRUCTION_WIDTH - 1:0] instruction,
    input wire [$clog2(IMM_MODE_NUMS) - 1:0] imm_sel,
    output reg [INSTRUCTION_WIDTH - 1:0] imm_out
    );
    always@(*) begin
        case(imm_sel) 
            3'b000: begin
                imm_out[31:11] = {21{instruction[31]}};
                imm_out[10:0] = instruction[30:20];
            end //I_immediate sign extend
            3'b001: begin
                imm_out [31:11] = {21{1'b0}};
                imm_out[10:0] = instruction[30:20];
            end
            3'b010: begin
                imm_out[31:11] = {21{instruction[31]}};
                imm_out[10:5] = instruction[30:25];  
                imm_out[4:0] = instruction[11:7]; 
            end//S_immediate
            3'b011: begin
                imm_out[31:12] = {20{instruction[31]}}; 
                imm_out[11] = instruction[7]; 
                imm_out[10:5] = instruction[30:25];
                imm_out[4:1] = instruction[11:8];
                imm_out[0] = 1'b0; //B_immediate
            end
            3'b100: begin
                imm_out[31:12] = instruction[31:12];
                imm_out[11:0] = 12'h000; 
            end//U_immediate
            3'b101: begin
                imm_out[31:20] = {12{instruction[31]}};
                imm_out[19:12] = instruction[19:12];
                imm_out[11] = instruction[20];
                imm_out[10:5] = instruction[30:25];
                imm_out[4:1] = instruction[24:21];
                imm_out[0] = 1'b0; //J_immediate
            end
            default: imm_out = 32'h0000_0000;
        endcase
        
    end
endmodule
