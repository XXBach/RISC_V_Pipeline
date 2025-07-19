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
    RISCV_IO.Assertion rsc_io;
    
    extern function new(string name = "Assertion", virtual RISCV_IO.Assertion rsc_io);
    extern task running_assertion();
    extern function void display();

endclass: Assertion
    function Assertion::new(string name, virtual RISCV_IO.Assertion rsc_io);
        this.name = name;
        this.rsc_io = rsc_io;
    endfunction:new
    task Assertion::running_assertion();
        // Top module internal signals
        // IF_ID
        logic prev_Top_PCSel;
        logic [$clog2(IMM_MODE_NUMS) - 1:0] prev_Top_ImmSel;
        logic prev_Top_RegWEn;
        logic prev_Top_BrUn;
        logic prev_Top_BrEq;
        logic prev_Top_BrLt;
        logic prev_Top_ASel;
        logic prev_Top_BSel;
        logic [$clog2(OPERATION_NUMS) - 1:0] prev_Top_ALU_Sel;
        logic prev_Top_MemRW;
        logic [1:0] prev_Top_WBSel;
        logic [INSTRUCTION_WIDTH - 1:0] prev_Top_instruction_ctrl;
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
        
        //Datapath
        //IF
        logic [ADDR_WIDTH - 1:0] prev_DTP_accumulated_addr_IF;
        //IF_ID
        logic [DATA_WIDTH - 1:0] prev_DTP_ALU_result_ID;
        logic [INSTRUCTION_WIDTH - 1:0] prev_DTP_instruction;
        //ID
        logic [DATA_WIDTH - 1:0] prev_DTP_WB_Output;
        //ID_Exe
        logic [ADDR_WIDTH - 1:0] prev_DTP_Current_PC_Exe;
        logic [ADDR_WIDTH - 1:0] prev_DTP_accumulated_addr_Exe;
        logic [DATA_WIDTH - 1:0] prev_DTP_rs1;
        logic [DATA_WIDTH - 1:0] prev_DTP_rs2;
        logic [DATA_WIDTH - 1:0] prev_DTP_imm_Exe;
        //Exe_MA
        logic [DATA_WIDTH - 1:0] prev_DTP_ALU_result_MA;
        logic [ADDR_WIDTH - 1:0] prev_DTP_accumulated_addr_MA;
        logic [DATA_WIDTH - 1:0] prev_DTP_Data_W;
        //MA_WB
        logic prev_DTP_MemRW;
        logic [1:0] prev_DTP_WBSel;
        logic [DATA_WIDTH - 1:0] prev_DTP_WB_Output;
        
        //Controller
        logic [INSTRUCTION_WIDTH - 1:0] prev_CTRL_instruction;
        logic prev_CTRL_is_ALU; 
        forever begin
            @(posedge rsc_io.clk);
            if(!rsc_io.reset) begin
                //Controller Assertion
                //assert(rsc_io.CTRL_instruction_ff == $past(rsc_io.CTRL_instruction));
                //unable to use $past
                prev_CTRL_instruction = rsc_io.CTRL_instruction;
                prev_CTRL_is_ALU = rsc_io.CTRL_is_ALU;
                assert(rsc_io.CTRL_instruction_ALU == prev_CTRL_instruction) else $error("[%t] Instruction in CTRL failed to transfer to ALU Controller| expected instruction: %b| received instruction: %b", $time, prev_CTRL_instruction, rsc_io.CTRL_instruction_ALU); 
                assert(rsc_io.CTRL_is_ALU_ff == prev_CTRL_is_ALU) else $error("[%t] is_ALU failed to transfer to ALU Controller| expected signal: %b| received signal: %b", $time, prev_CTRL_is_ALU, rsc_io.CTRL_is_ALU_ff);
                
                //Datapath Assertion
                
            end
        end
    endtask:running_assertion    