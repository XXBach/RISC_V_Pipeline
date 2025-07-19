`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 10:52:37 AM
// Design Name: 
// Module Name: RISCV_test_top
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


module RISCV_test_top#(
    parameter Simulation_Cycles = 3000,
    parameter INSTRUCTION_WIDTH = 32,
    parameter OPERATION_NUMS = 16,
    parameter IMM_MODE_NUMS = 8,
    
    //Datapath Params
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32,
    parameter DMEM_DEPTH = 1024,
    parameter IMEM_LENGTH = 65536,
    parameter PC_WIDTH = 16,
    parameter REGFILE_DEPTH = 32
);
    bit System_Clock;
    RISCV_IO#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .OPERATION_NUMS(OPERATION_NUMS),
        .IMM_MODE_NUMS(IMM_MODE_NUMS),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH),
        .IMEM_LENGTH(IMEM_LENGTH),
        .PC_WIDTH(PC_WIDTH),
        .REGFILE_DEPTH(REGFILE_DEPTH)
    ) RISCV_interface (
        System_Clock
    );
    
endmodule: RISCV_test_top
