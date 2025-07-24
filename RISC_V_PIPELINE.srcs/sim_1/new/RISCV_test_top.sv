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

`include "RISCV_IO.sv"
`include "Top_Binding.sv"
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
    
    //
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
    
    RISCV_test Structural_TB (RISCV_interface.Test);
    
    RISCV#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .OPERATION_NUMS(OPERATION_NUMS),
        .IMM_MODE_NUMS(IMM_MODE_NUMS),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH),
        .IMEM_LENGTH(IMEM_LENGTH),
        .PC_WIDTH(PC_WIDTH),
        .REGFILE_DEPTH(REGFILE_DEPTH)
    )DUT(
        .clk(System_Clock),
        .reset(RISCV_interface.reset),
        .start(RISCV_interface.start),
        .IMem_Start(RISCV_interface.IMem_Start),
        .Current_PC(RISCV_interface.Current_PC),
        .instruction(RISCV_interface.instruction),
        .data_r_0(RISCV_interface.data_r_0),
        .data_r_1(RISCV_interface.data_r_1),
        .imm_out(RISCV_interface.imm_out),
        .ALU_Result(RISCV_interface.ALU_Result),
        .WB_Output(RISCV_interface.WB_Output)
    );
    
    bind RISCV Top_Binding inner_signal_bind (
        .rsc_io_A(RISCV_interface.Assertion),
        .PCSel(PCSel),
        .RegWEn(RegWEn),
        .ASel(ASel),
        .BSel(BSel),
        .MemRW(MemRW),
        .WBSel(WBSel),
        .PCSel_Exe(PCSel_Exe),
        .RegWEn_Exe(RegWEn_Exe),
        .ASel_Exe(ASel_Exe),
        .BSel_Exe(BSel_Exe),
        .MemRW_Exe(MemRW_Exe),
        .WBSel_Exe(WBSel_Exe),
        .PCSel_MA(PCSel_MA),
        .RegWEn_MA(RegWEn_MA),
        .MemRW_MA(MemRW_MA),
        .WBSel_MA(WBSel_MA),
        .PCSel_WB(PCSel_WB),
        .RegWEn_WB(RegWEn_WB),
        .WBSel_WB(WBSel_WB),
        .PCSel_IF(PCSel_IF),
        .RegWEn_IF(RegWEn_IF)
    );
    initial begin
        System_Clock = 0;
        forever #5 System_Clock = ~System_Clock;
    end
endmodule: RISCV_test_top
