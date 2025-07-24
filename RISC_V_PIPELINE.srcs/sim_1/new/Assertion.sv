`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 10:23:49 AM
// Design Name: 
// Module Name: Assertion
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

`ifndef ASSERTION
`define ASSERTION
class Assertion#(
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
);
    string name;
    virtual RISCV_IO.Assertion rsc_io;
    
    extern function new(string name = "Assertion", virtual RISCV_IO.Assertion rsc_io);
    extern task running_assertion();

endclass: Assertion
    function Assertion::new(string name, virtual RISCV_IO.Assertion rsc_io);
        this.name = name;
        this.rsc_io = rsc_io;
    endfunction:new
    task Assertion::running_assertion();
        // Top module internal signals
        //ID_Exe
        logic prev_Top_PCSel_Exe;
        logic prev_Top_RegWEn_Exe;
        logic prev_Top_ASel_Exe;
        logic prev_Top_BSel_Exe;
        logic prev_Top_MemRW_Exe;
        logic [1:0] prev_Top_WBSel_Exe;
        //Exe_MA
        logic prev_Top_PCSel_MA;
        logic prev_Top_RegWEn_MA;
        logic prev_Top_MemRW_MA;
        logic [1:0] prev_Top_WBSel_MA;
        //MA_WB
        logic prev_Top_PCSel_WB;
        logic prev_Top_RegWEn_WB;
        logic [1:0] prev_Top_WBSel_WB;
        //WB_IF
        logic prev_Top_PCSel_IF;
        logic prev_Top_RegWEn_IF;
        
        forever begin
            @(rsc_io.RISCV_cb);
            if(!rsc_io.reset) begin
                //assert(rsc_io.CTRL_instruction_ff == $past(rsc_io.CTRL_instruction));
                //unable to use $past in vivado
                //ID_Exe
                prev_Top_PCSel_Exe = rsc_io.Top_PCSel;
                prev_Top_RegWEn_Exe = rsc_io.Top_RegWEn;
                prev_Top_ASel_Exe = rsc_io.Top_ASel;
                prev_Top_BSel_Exe = rsc_io.Top_BSel;
                prev_Top_MemRW_Exe = rsc_io.Top_MemRW;
                prev_Top_WBSel_Exe = rsc_io.Top_WBSel;
                assert(rsc_io.Top_PCSel_Exe == prev_Top_PCSel_Exe) else $warning("Fail! PCSel from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_PCSel_Exe, prev_Top_PCSel_Exe);
                assert(rsc_io.Top_RegWEn_Exe == prev_Top_RegWEn_Exe) else $warning("Fail! RegWEn from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_RegWEn_Exe, prev_Top_RegWEn_Exe);
                assert(rsc_io.Top_ASel_Exe == prev_Top_ASel_Exe) else $warning("Fail! ASel from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_ASel_Exe, prev_Top_ASel_Exe);
                assert(rsc_io.Top_BSel_Exe == prev_Top_BSel_Exe) else $warning("Fail! BSel from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_BSel_Exe, prev_Top_BSel_Exe);
                assert(rsc_io.Top_MemRW_Exe == prev_Top_MemRW_Exe) else $warning("Fail! MemRW from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_MemRW_Exe, prev_Top_MemRW_Exe);
                assert(rsc_io.Top_WBSel_Exe == prev_Top_WBSel_Exe) else $warning("Fail! WBSel from ID to Exe: Expected: %d, Received: %d", rsc_io.Top_WBSel_Exe, prev_Top_WBSel_Exe);
                
                //Exe_MA
                prev_Top_PCSel_MA = rsc_io.Top_PCSel_Exe;
                prev_Top_RegWEn_MA = rsc_io.Top_RegWEn_Exe;
                prev_Top_MemRW_MA = rsc_io.Top_MemRW_Exe;
                prev_Top_WBSel_MA = rsc_io.Top_WBSel_Exe;
                assert(rsc_io.Top_PCSel_MA == prev_Top_PCSel_MA) else $warning("Fail! PCSel from Exe to MA: Expected: %d, Received: %d", rsc_io.Top_PCSel_MA, prev_Top_PCSel_MA);
                assert(rsc_io.Top_RegWEn_MA == prev_Top_RegWEn_MA) else $warning("Fail! RegWEn from Exe to MA: Expected: %d, Received: %d", rsc_io.Top_RegWEn_MA, prev_Top_RegWEn_MA);
                assert(rsc_io.Top_MemRW_MA == prev_Top_MemRW_MA) else $warning("Fail! MemRW from Exe to MA: Expected: %d, Received: %d", rsc_io.Top_MemRW_MA, prev_Top_MemRW_MA);
                assert(rsc_io.Top_WBSel_MA == prev_Top_WBSel_MA) else $warning("Fail! WBSel from Exe to MA: Expected: %d, Received: %d", rsc_io.Top_WBSel_MA, prev_Top_WBSel_MA);
                
                //MA_WB
                prev_Top_PCSel_WB = rsc_io.Top_PCSel_MA;
                prev_Top_RegWEn_WB = rsc_io.Top_RegWEn_MA;
                prev_Top_WBSel_WB = rsc_io.Top_WBSel_MA;
                assert(rsc_io.Top_PCSel_WB == prev_Top_PCSel_WB) else $warning("Fail! PCSel from MA to WB: Expected: %d, Received: %d", rsc_io.Top_PCSel_WB, prev_Top_PCSel_WB);
                assert(rsc_io.Top_RegWEn_WB == prev_Top_RegWEn_WB) else $warning("Fail! RegWEn from MA to WB: Expected: %d, Received: %d", rsc_io.Top_RegWEn_WB, prev_Top_RegWEn_WB);
                assert(rsc_io.Top_WBSel_WB == prev_Top_WBSel_WB) else $warning("Fail! WBSel from MA to WB: Expected: %d, Received: %d", rsc_io.Top_WBSel_WB, prev_Top_WBSel_WB);
                
                //WB_IF
                prev_Top_PCSel_IF = rsc_io.Top_PCSel_WB;
                prev_Top_RegWEn_IF = rsc_io.Top_RegWEn_WB;
                assert(rsc_io.Top_PCSel_IF == prev_Top_PCSel_IF) else $warning("Fail! PCSel from WB to IF: Expected: %d, Received: %d", rsc_io.Top_PCSel_IF, prev_Top_PCSel_IF);
                assert(rsc_io.Top_RegWEn_IF == prev_Top_RegWEn_IF) else $warning("Fail! RegWEn from WB to IF: Expected: %d, Received: %d", rsc_io.Top_RegWEn_IF, prev_Top_RegWEn_IF);
            
            end
        end
    endtask:running_assertion
    
`endif    