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

`ifndef TOP_BINDING
`define TOP_BINDING
module Top_Binding(
    RISCV_IO.Assertion rsc_io_A,
    //IF_ID
    input PCSel,
    input RegWEn,
    input ASel,
    input BSel,
    input MemRW,
    input [1:0] WBSel,
    //ID_Exe
    input PCSel_Exe,
    input RegWEn_Exe,
    input ASel_Exe,
    input BSel_Exe,
    input MemRW_Exe,
    input [1:0] WBSel_Exe,
    //Exe_MA
    input PCSel_MA,
    input RegWEn_MA,
    input MemRW_MA,
    input [1:0] WBSel_MA,
    //MA_WB
    input PCSel_WB,
    input RegWEn_WB,
    input [1:0] WBSel_WB,
    //WB_IF
    input PCSel_IF,
    input RegWEn_IF
    );
    
    always_ff @(rsc_io_A.RISCV_cb) begin
    //IF_ID
    rsc_io_A.Top_PCSel = PCSel;
    rsc_io_A.Top_RegWEn = RegWEn;
    rsc_io_A.Top_ASel = ASel;
    rsc_io_A.Top_BSel = BSel;
    rsc_io_A.Top_MemRW = MemRW;
    rsc_io_A.Top_WBSel = WBSel;
    //ID_Exe
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
`endif