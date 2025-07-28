`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 04:01:25 PM
// Design Name: 
// Module Name: RISCV
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


module RISCV#(
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
    //Global input
    input wire clk,
    input wire reset,
    input wire start,
    //Output checking
    output wire [ADDR_WIDTH - 1:0] Current_PC,
    output wire [INSTRUCTION_WIDTH - 1:0] instruction,
    output wire [DATA_WIDTH - 1:0] data_r_0,
    output wire [DATA_WIDTH - 1:0] data_r_1,
    output wire [INSTRUCTION_WIDTH - 1:0] imm_out,
    output wire [DATA_WIDTH - 1:0] ALU_Result,
    output wire [DATA_WIDTH - 1:0] WB_Output
);

    //Control Signal
    wire PCSel;
    wire [$clog2(IMM_MODE_NUMS) - 1:0] ImmSel;
    wire RegWEn;
    wire BrUn;
    wire BrEq;
    wire BrLt;
    wire ASel;
    wire BSel;
    wire [$clog2(OPERATION_NUMS) - 1:0] ALU_Sel;
    wire MemRW;
    wire [1:0] WBSel;
    reg [INSTRUCTION_WIDTH - 1:0] instruction_ctrl;
    
    //Controller Initiation
    Controller#(
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .OPERATION_NUMS(OPERATION_NUMS),
        .IMM_MODE_NUMS(IMM_MODE_NUMS)
    )CTRL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .instruction(instruction_ctrl),
        .BrEq(BrEq),
        .BrLt(BrLt),
        .PCSel(PCSel),
        .ImmSel(ImmSel),
        .RegWEn(RegWEn),
        .BrUn(BrUn),
        .ASel(ASel),
        .BSel(BSel),
        .ALUSel(ALU_Sel),
        .MemRW(MemRW),
        .WBSel(WBSel)
    );
    
    //Control Signals Delay by Stages
    //ID_Exe ( ALUSel, ImmSel and BrUn are not delayed )
    reg PCSel_Exe;
    reg RegWEn_Exe;
    reg ASel_Exe;
    reg BSel_Exe;
    reg MemRW_Exe;
    reg [1:0] WBSel_Exe;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PCSel_Exe <= 0;
            RegWEn_Exe <= 0;
            ASel_Exe <= 0;
            BSel_Exe <= 0;
            MemRW_Exe <= 0;
            WBSel_Exe <= 0;
            instruction_ctrl <= 0;
        end
        else begin
            PCSel_Exe <= PCSel;
            RegWEn_Exe <= RegWEn;
            ASel_Exe <= ASel;
            BSel_Exe <= BSel;
            MemRW_Exe <= MemRW;
            WBSel_Exe <= WBSel;
            instruction_ctrl <= instruction;
        end
    end
    
    //Exe_MA ( ASel and BSel are not delayed )
    reg PCSel_MA;
    reg RegWEn_MA;
    reg MemRW_MA;
    reg [1:0] WBSel_MA;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PCSel_MA <= 0;
            RegWEn_MA <= 0;
            MemRW_MA <= 0;
            WBSel_MA <= 0;
        end
        else begin
            PCSel_MA <= PCSel_Exe;
            RegWEn_MA <= RegWEn_Exe;
            MemRW_MA <= MemRW_Exe;
            WBSel_MA <= WBSel_Exe;
        end
    end
    
    //MA_WB ( MemRW is not delayed )
    reg PCSel_WB;
    reg RegWEn_WB;
    reg [1:0] WBSel_WB;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PCSel_WB <= 0;
            RegWEn_WB <= 0;
            WBSel_WB <= 0;
        end
        else begin
            PCSel_WB <= PCSel_MA;
            RegWEn_WB <= RegWEn_MA;
            WBSel_WB <= WBSel_MA;
        end
    end
    
    //WB_IF ( WBSel is not delayed )
    reg PCSel_IF;
    reg RegWEn_IF;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PCSel_IF <= 0;
            RegWEn_IF <= 0;
        end
        else begin
            PCSel_IF <= PCSel_WB;
            RegWEn_IF <= RegWEn_WB;
        end
    end
    
    //Datapath initiation   
    Datapath #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH),
        .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
        .IMEM_LENGTH(IMEM_LENGTH),
        .IMM_MODE_NUMS(IMM_MODE_NUMS),
        .OPERATION_NUMS(OPERATION_NUMS),
        .PC_WIDTH(PC_WIDTH),
        .REGFILE_DEPTH(REGFILE_DEPTH)
    ) DTPH (
        .clk(clk),
        .reset(reset),
        .IMem_Start(start),
        .PCSel(PCSel_IF),
        .ImmSel(ImmSel),
        .RegWEn(RegWEn_IF),
        .BrUn(BrUn),
        .ASel(ASel_Exe),
        .BSel(BSel_Exe),
        .ALU_Sel(ALU_Sel),
        .MemRW(MemRW_MA),
        .WBSel(WBSel_WB),
        .BrEq(BrEq),
        .BrLt(BrLt),
        .Current_PC(Current_PC),
        .instruction(instruction),
        .data_r_0(data_r_0),
        .data_r_1(data_r_1),
        .imm_out(imm_out),
        .ALU_Result(ALU_Result),
        .WB_Output(WB_Output)
    );
    
endmodule
