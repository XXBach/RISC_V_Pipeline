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
    // Top module input, output
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
    
    // Top module internal signals
    // IF_ID
    logic Top_PCSel;
    logic [$clog2(IMM_MODE_NUMS) - 1:0] Top_ImmSel;
    logic Top_RegWEn;
    logic Top_BrUn;
    logic Top_BrEq;
    logic Top_BrLt;
    logic Top_ASel;
    logic Top_BSel;
    logic [$clog2(OPERATION_NUMS) - 1:0] Top_ALU_Sel;
    logic Top_MemRW;
    logic [1:0] Top_WBSel;
    logic [INSTRUCTION_WIDTH - 1:0] Top_instruction_ctrl;
    //ID_Exe
    logic Top_PCSel_Exe;
    logic Top_RegWEn_Exe;
    logic Top_ASel_Exe;
    logic Top_BSel_Exe;
    logic Top_MemRW_Exe;
    logic [1:0] Top_WBSel_Exe;
    //Exe_MA
    logic Top_PCSel_MA;
    logic Top_RegWEn_MA;
    logic Top_MemRW_MA;
    logic [1:0] Top_WBSel_MA;
    //MA_WB
    logic Top_PCSel_WB;
    logic Top_RegWEn_WB;
    logic [1:0] Top_WBSel_WB;
    //WB_IF
    logic Top_PCSel_IF;
    logic Top_RegWEn_IF;
    
    //Datapath
    //IF
    logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_IF;
    logic [ADDR_WIDTH - 1:0] DTP_ALU_addr_IF;
    //IF_ID
    logic [ADDR_WIDTH - 1:0] DTP_Current_PC_ID;
    logic [DATA_WIDTH - 1:0] DTP_ALU_result_ID;
    logic [INSTRUCTION_WIDTH - 1:0] DTP_instruction_ID;
    logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_ID;
    //ID
    logic [DATA_WIDTH - 1:0] DTP_WB_Output;
    //ID_Exe
    logic [ADDR_WIDTH - 1:0] DTP_Current_PC_Exe;
    logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_Exe;
    logic [DATA_WIDTH - 1:0] DTP_rs1;
    logic [DATA_WIDTH - 1:0] DTP_rs2;
    logic [DATA_WIDTH - 1:0] DTP_imm_Exe;
    //Exe_MA
    logic [DATA_WIDTH - 1:0] DTP_ALU_result_MA;
    logic [ADDR_WIDTH - 1:0] DTP_accumulated_addr_MA;
    logic [DATA_WIDTH - 1:0] DTP_Data_W;
    //MA_WB
    logic DTP_MemRW;
    logic [1:0] DTP_WBSel;
    logic [DATA_WIDTH - 1:0] DTP_WB_Output;
    
    //Controller
    logic [INSTRUCTION_WIDTH - 1:0]CTRL_instruction;
    logic CTRL_is_ALU_ff;
    logic CTRL_is_ALU; 
    logic [INSTRUCTION_WIDTH - 1:0] CTRL_instruction_ALU;
    
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
