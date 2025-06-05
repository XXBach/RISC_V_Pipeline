`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 09:35:02 AM
// Design Name: 
// Module Name: RISCV_IO
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


interface RISCV_IO#(
    //Controller Params
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
)(
    input bit clock
);
    logic clk;
    assign clk = clock;
    logic reset;
    logic start;
    logic IMem_Start;
    logic [ADDR_WIDTH - 1:0] Current_PC;
    logic [DATA_WIDTH - 1:0] instruction;
    logic [DATA_WIDTH - 1:0] data_r_0;
    logic [DATA_WIDTH - 1:0] data_r_1;
    logic [INSTRUCTION_WIDTH - 1:0] imm_out;
    logic [DATA_WIDTH - 1:0] ALU_Result;
    logic [DATA_WIDTH - 1:0] WB_Output;
    clocking RISCV_cb @(posedge clock);
        default input #0 output #0;
        output reset;
        output start;
        output IMem_Start;
        input Current_PC;
        input instruction;
        input data_r_0;
        input data_r_1;
        input imm_out;
        input ALU_Result;
        input WB_Output;
     endclocking: RISCV_cb
     modport Test(clocking RISCV_cb,output reset);
     modport DUT(input reset, start, IMem_Start,
                    output Current_PC, instruction, data_r_0,
                    data_r_1, imm_out, ALU_Result, WB_Output);
     modport Assertion (output reset, start, IMem_Start, Current_PC, instruction, data_r_0,
                    data_r_1, imm_out, ALU_Result, WB_Output);
endinterface: RISCV_IO
