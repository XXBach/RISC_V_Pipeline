`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 09:09:04 PM
// Design Name: 
// Module Name: Instruction_Fetch
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


module Instruction_Fetch#(
    parameter ADDR_WIDTH = 16,
    parameter INSTRUCTION_WIDTH = 32,
    parameter IMEM_LENGTH = 65536
)(
    input wire clk,
    input wire reset,
    input wire PCSel,
    input wire IMem_Start,
    input wire [ADDR_WIDTH - 1:0] ALU_addr,
    output wire [ADDR_WIDTH - 1:0] current_addr,
    output wire [ADDR_WIDTH - 1:0] accumulated_addr_op,
    output wire [INSTRUCTION_WIDTH - 1:0] instruction    
    );
    wire [ADDR_WIDTH - 1:0] next_addr;
    Mux2_to_1#(
        .DATA_WIDTH(ADDR_WIDTH)
    )IF_mux(
        .Sel(PCSel),
        .A(accumulated_addr_op),
        .B(ALU_addr),
        .C(next_addr)
    );
    PC#(
        .ADDR_WIDTH(ADDR_WIDTH)
    )Program_Counter(
        .clk(clk),
        .reset(reset),
        .Next_Addr(next_addr),
        .Current_Addr(current_addr)
    );
    Acc#(
        .DATA_WIDTH(ADDR_WIDTH)
    )Accumulator(
        .data_in(current_addr),
        .accumulated_data(accumulated_addr_op)
    );
    IMEM#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .IMEM_LENGTH(IMEM_LENGTH)
    )Instruction_mem(
        .clk(clk),
        .reset(reset),
        .start(IMem_Start),
        .addr(current_addr),
        .instruction(instruction)
    );
endmodule
