`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2025 04:59:08 PM
// Design Name: 
// Module Name: Datapath
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


module Datapath#(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32,
    parameter DMEM_DEPTH = 1024,
    parameter INSTRUCTION_WIDTH = 32,
    parameter IMEM_LENGTH = 65536,
    parameter IMM_MODE_NUMS = 8,
    parameter OPERATION_NUMS = 16,
    parameter PC_WIDTH = 16,
    parameter REGFILE_DEPTH = 32
)(
    //Global input
    input wire clk,
    input wire reset,
    input wire IMem_Start,
    //input control
    input wire PCSel,
    input wire [2:0] ImmSel,
    input wire RegWEn,
    input wire BrUn,
    input wire ASel,
    input wire BSel,
    input wire [$clog2(OPERATION_NUMS) - 1:0] ALU_Sel,
    input wire MemRW,
    input wire [1:0] WBSel,
    
    //output control
    output wire BrEq,
    output wire BrLt,
    
    //output checking
    output wire [ADDR_WIDTH - 1:0] Current_PC,
    output wire [INSTRUCTION_WIDTH - 1:0] instruction,
    output wire [DATA_WIDTH - 1:0] data_r_0,
    output wire [DATA_WIDTH - 1:0] data_r_1,
    output wire [INSTRUCTION_WIDTH - 1:0] imm_out,
    output wire [DATA_WIDTH - 1:0] ALU_Result,
    output wire [DATA_WIDTH - 1:0] WB_Output
    );
    // Instruction Fetch stage
    wire [ADDR_WIDTH - 1:0] accumulated_addr_IF;
    reg [ADDR_WIDTH - 1:0] ALU_addr_IF;
    Instruction_Fetch#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .IMEM_LENGTH(IMEM_LENGTH)
    )IF(
        .clk(clk),
        .reset(reset),
        .IMem_Start(IMem_Start),
        .PCSel(PCSel),
        .ALU_addr(ALU_addr_IF),
        .current_addr(Current_PC),
        .accumulated_addr_op(accumulated_addr_IF),
        .instruction(instruction)
    );
    
    // Instruction Fetch to Instruction Decode Regs
    reg [ADDR_WIDTH - 1:0] Current_PC_ID;
    reg [DATA_WIDTH - 1:0] ALU_result_ID;
    reg [INSTRUCTION_WIDTH - 1:0] instruction_ID;
    reg [ADDR_WIDTH - 1:0] accumulated_addr_ID;
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            Current_PC_ID <= 0;
            instruction_ID <= 0;
            accumulated_addr_ID <= 0;
            ALU_addr_IF <= 0;
        end
        else begin
            Current_PC_ID <= Current_PC;
            instruction_ID <= instruction;
            accumulated_addr_ID <= accumulated_addr_IF;
            ALU_addr_IF <= ALU_result_ID;
        end
    end
    
    //Instruction Decode Stage 
    RegFile#(
        .DATA_WIDTH(DATA_WIDTH),
        .REGFILE_DEPTH(REGFILE_DEPTH)
    )RF(
        .clk(clk),
        .reset(reset),
        .wen(RegWEn),
        .addr_r_0(instruction_ID[19:15]),
        .addr_r_1(instruction_ID[24:20]),
        .addr_w(instruction_ID[11:7]),
        .data_w(WB_Output),
        .data_r_0(data_r_0),
        .data_r_1(data_r_1)
    );
    ImmGen#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .IMM_MODE_NUMS(IMM_MODE_NUMS)
    )Imm(
        .instruction(instruction_ID),
        .imm_sel(ImmSel),
        .imm_out(imm_out)
    );
    Branch_Compare#(
        .DATA_WIDTH(DATA_WIDTH)
    )BC(
        .BrUn(BrUn),
        .A(data_r_0),
        .B(data_r_1),
        .BrLT(BrLt),
        .BrEq(BrEq)
    );
    
    //Instruction Decode to Execution
    reg [ADDR_WIDTH - 1:0] Current_PC_Exe;
    reg [ADDR_WIDTH - 1:0] accumulated_addr_Exe;
    reg [DATA_WIDTH - 1:0] rs1;
    reg [DATA_WIDTH - 1:0] rs2;
    reg [DATA_WIDTH - 1:0] imm_Exe;
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            Current_PC_Exe <= 0;
            accumulated_addr_Exe <= 0;
            ALU_result_ID <= 0;
            rs1 <= 0;
            rs2 <= 0;
            imm_Exe <= 0;
        end
        else begin
            Current_PC_Exe <= Current_PC_ID;
            accumulated_addr_Exe <= accumulated_addr_ID;
            ALU_result_ID <= ALU_Result;
            rs1 <= data_r_0;
            rs2 <= data_r_1;
            imm_Exe <= imm_out;
        end
    end
    
    //Execution Stage
    Execution#(
        .DATA_WIDTH(DATA_WIDTH),
        .PC_WIDTH(PC_WIDTH),
        .OPERATION_NUMS(OPERATION_NUMS)
    )Exe(
        .ASel(ASel),
        .BSel(BSel),
        .ALU_Sel(ALU_Sel),
        .PC(Current_PC_Exe),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm_Exe),
        .Result(ALU_Result)
    );
    
    //Execution to Memory Access
    reg [DATA_WIDTH - 1:0] ALU_result_MA;
    reg [ADDR_WIDTH - 1:0] accumulated_addr_MA;
    reg [DATA_WIDTH - 1:0] Data_W;
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            Data_W <= 0;
            accumulated_addr_MA <= 0;
            ALU_result_MA <= 0;
        end
        else begin
            Data_W <= rs2;
            accumulated_addr_MA <= accumulated_addr_Exe;
            ALU_result_MA <= ALU_Result;
        end
    end
    
    //Memory Access + Write Back
    Memory_Access#(
        .DATA_WIDTH(DATA_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH)
    )MA_WB(
        .clk(clk),
        .reset(reset),
        .MemRW(MemRW),
        .WBSel(WBSel),
        .ExeResult(ALU_result_MA),
        .PC4(accumulated_addr_MA),
        .DataW(Data_W),
        .DataWb(WB_Output)
    );
endmodule
