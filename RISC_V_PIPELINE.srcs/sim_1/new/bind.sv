`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2025 10:39:02 AM
// Design Name: 
// Module Name: bind
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
module Controller_binding#(
    parameter INSTRUCTION_WIDTH = 32
)(
    input logic CTRL_instruction,
    input logic CTRL_is_ALU_ff,
    input logic CTRL_is_ALU,
    input logic [INSTRUCTION_WIDTH - 1:0] CTRL_instruction_ALU,
    RISCV_IO io
    );
    always_ff @(posedge io.clk) begin
        io.CTRL_instruction <= CTRL_instruction;
        io.CTRL_is_ALU_ff <= CTRL_is_ALU_ff;
        io.CTRL_is_ALU <= CTRL_is_ALU;
        io.CTRL_instruction_ALU <= CTRL_instruction_ALU;
    end  
endmodule

//////////////////////////////////////////////////////////////////////////////////

module Datapath_binding#(
    parameter INSTRUCTION_WIDTH = 32,
    //Datapath Params
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32,
    parameter DMEM_DEPTH = 1024,
    parameter IMEM_LENGTH = 65536,
    parameter PC_WIDTH = 16,
    parameter REGFILE_DEPTH = 32
)(
    //IF
    input logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_IF,
    input logic [ADDR_WIDTH - 1:0] DTP_ALU_addr_IF,
    //IF_ID
    input logic [ADDR_WIDTH - 1:0] DTP_Current_PC_ID,
    input logic [DATA_WIDTH - 1:0] DTP_ALU_result_ID,
    input logic [INSTRUCTION_WIDTH - 1:0] DTP_instruction_ID,
    input logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_ID,
    //ID
    input logic [DATA_WIDTH - 1:0] DTP_WB_Output,
    //ID_Exe
    input logic [ADDR_WIDTH - 1:0] DTP_Current_PC_Exe,
    input logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_Exe,
    input logic [DATA_WIDTH - 1:0] DTP_rs1,
    input logic [DATA_WIDTH - 1:0] DTP_rs2,
    input logic [DATA_WIDTH - 1:0] DTP_imm_Exe,
    //Exe_MA
    input logic [DATA_WIDTH - 1:0] DTP_ALU_result_MA,
    input logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_MA,
    input logic [DATA_WIDTH - 1:0] DTP_Data_W,
    //MA_WB
    input logic DTP_MemRW,
    input logic [1:0] DTP_WBSel,
    input logic [DATA_WIDTH - 1:0] DTP_WB_Output,
    RISCV_IO io
    );
    always_ff @(posedge io.clk) begin
        io.DTP_accumulated_addr_IF <= DTP_accumulated_addr_IF;
        io.DTP_ALU_addr_IF <= DTP_ALU_addr_IF;
        io.DTP_Current_PC_ID <= DTP_Current_PC_ID;
        io.DTP_ALU_result_ID <= DTP_ALU_result_ID;
        io.DTP_instruction_ID <= DTP_instruction_ID;
        io.DTP_accumulated_addr_ID <= DTP_accumulated_addr_ID;
        io.DTP_WB_Output <= DTP_WB_Output;
        io.DTP_Current_PC_Exe <= DTP_Current_PC_Exe;
        io.DTP_accumulated_addr_Exe <= DTP_accumulated_addr_Exe;
        io.DTP_rs1 <= DTP_rs1;
        io.DTP_rs2 <= DTP_rs2;
        io.DTP_imm_Exe <= DTP_imm_Exe;
        io.DTP_ALU_result_MA <= DTP_ALU_result_MA;
        io.DTP_accumulated_addr_MA <= DTP_accumulated_addr_MA;
        io.DTP_Data_W <= DTP_Data_W;
        io.DTP_MemRW <= DTP_MemRW;
        io.DTP_WBSel <= DTP_WBSel;
        io.DTP_WB_Output <= DTP_WB_Output;
    end  
endmodule

//////////////////////////////////////////////////////////////////////////////////

module Top_binding#(
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
    // IF_ID
    input logic Top_PCSel,
    input logic [$clog2(IMM_MODE_NUMS) - 1:0] Top_ImmSel,
    input logic Top_RegWEn,
    input logic Top_BrUn,
    input logic Top_BrEq,
    input logic Top_BrLt,
    input logic Top_ASel,
    input logic Top_BSel,
    input logic [$clog2(OPERATION_NUMS) - 1:0] Top_ALU_Sel,
    input logic Top_MemRW,
    input logic [1:0] Top_WBSel,
    input logic [INSTRUCTION_WIDTH - 1:0] Top_instruction_ctrl,
    //ID_Exe
    input logic Top_PCSel_Exe,
    input logic Top_RegWEn_Exe,
    input logic Top_ASel_Exe,
    input logic Top_BSel_Exe,
    logic Top_MemRW_Exe,
    logic [1:0] Top_WBSel_Exe,
    //Exe_MA
    logic Top_PCSel_MA,
    logic Top_RegWEn_MA,
    logic Top_MemRW_MA,
    logic [1:0] Top_WBSel_MA,
    //MA_WB
    logic Top_PCSel_WB,
    logic Top_RegWEn_WB,
    logic [1:0] Top_WBSel_WB,
    //WB_IF
    logic Top_PCSel_IF,
    logic Top_RegWEn_IF,
    RISCV_IO io
    );
    always_ff @(posedge io.clk) begin
        io.Top_PCSel <= Top_PCSel;
        io.Top_ImmSel <= Top_ImmSel;
        io.Top_RegWEn <= Top_RegWEn;
        io.Top_BrUn <= Top_BrUn;
        io.Top_BrEq <= Top_BrEq;
        io.Top_BrLt <= Top_BrLt;
        io.Top_ASel <= Top_ASel;
        io.Top_BSel <= Top_BSel;
        io.Top_ALU_Sel <= Top_ALU_Sel;
        io.Top_MemRW <= Top_MemRW;
        io.Top_WBSel <= Top_WBSel;
        io.Top_instruction_ctrl <= Top_instruction_ctrl;
        io.Top_PCSel_Exe <= Top_PCSel_Exe;
        io.Top_RegWEn_Exe <= Top_RegWEn_Exe;
        io.Top_ASel_Exe <= Top_ASel_Exe;
        io.Top_BSel_Exe <= Top_BSel_Exe;
        io.Top_MemRW_Exe <= Top_MemRW_Exe;
        io.Top_WBSel_Exe <= Top_WBSel_Exe;
        io.Top_PCSel_MA <= Top_PCSel_MA;
        io.Top_RegWEn_MA <= Top_RegWEn_MA;
        io.Top_MemRW_MA <= Top_MemRW_MA;
        io.Top_WBSel_MA <= Top_WBSel_MA;
        io.Top_PCSel_WB <= Top_PCSel_WB;
        io.Top_RegWEn_WB <= Top_RegWEn_WB;
        io.Top_WBSel_WB <= Top_WBSel_WB;
        io.Top_PCSel_IF <= Top_PCSel_IF;
        io.Top_RegWEn_IF <= Top_RegWEn_IF;
    end  
endmodule