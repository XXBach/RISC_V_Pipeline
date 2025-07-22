`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 10:20:48 PM
// Design Name: 
// Module Name: Top_Binding
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


module Top_Binding(
    RISCV_IO.Assertion rsc_io_A,
    input logic clk,
    //ID_Exe
    logic PCSel_Exe,
    logic RegWEn_Exe,
    logic ASel_Exe,
    logic BSel_Exe,
    logic MemRW_Exe,
    logic [1:0] WBSel_Exe,
    //Exe_MA
    logic PCSel_MA,
    logic RegWEn_MA,
    logic MemRW_MA,
    logic [1:0] WBSel_MA,
    //MA_WB
    logic PCSel_WB,
    logic RegWEn_WB,
    logic [1:0] WBSel_WB,
    //WB_IF
    logic PCSel_IF,
    logic RegWEn_IF
    );
    
    always_ff @(posedge clk) begin
    rsc_io_A.Top_PCSel_Exe = PCSel_Exe;
    rsc_io_A.Top_RegWEn_Exe = RegWEn_Exe;
    rsc_io_A.Top_ASel_Exe = ASel_Exe;
    rsc_io_A.Top_BSel_Exe = BSel_Exe;
    rsc_io_A.Top_MemRW_Exe = MemRW_Exe;
    rsc_io_A.Top_WBSel_Exe = WBSel_Exe;
    //Exe_MA
    rsc_io_A.Top_PCSel_MA = PCSel_MA;
    rsc_io_A.Top_RegWEn_MA = RegWEn_MA;
    rsc_io_A.Top_MemRW_MA = MemRW_MA;
    rsc_io_A.Top_WBSel_MA = WBSel_MA;
    //MA_WB
    rsc_io_A.Top_PCSel_WB = PCSel_WB;
    rsc_io_A.Top_RegWEn_WB = RegWEn_WB;
    rsc_io_A.Top_WBSel_WB = WBSel_WB;
    //WB_IF
    rsc_io_A.Top_PCSel_IF = PCSel_IF;
    rsc_io_A.Top_RegWEn_IF = RegWEn_IF;
    end
endmodule
