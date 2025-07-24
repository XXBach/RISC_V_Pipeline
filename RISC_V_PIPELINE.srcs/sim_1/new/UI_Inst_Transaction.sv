`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 09:36:45 AM
// Design Name: 
// Module Name: UI_Inst_Transaction
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

`ifndef UI_TRANSACTION
`define UI_TRANSACTION
class UI_Inst_Transaction;
    //property declaration
    int ID;
    bit [6:0] opcode;
    rand bit [4:0] rd;
    rand bit [19:0] imm;
    bit [31:0] instruction;
    
    //adding constraint
    constraint opcode_cstr {
        opcode inside {7'b0110111, 7'b0010111};
    };
    
    //method prototype
    extern function new(int ID);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function UI_Inst_Transaction copy();
endclass: UI_Inst_Transaction

function UI_Inst_Transaction::new(int ID);
    this.ID = ID;
endfunction: new
    
function void UI_Inst_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %d| Instruction: %b| Status: %s", $time, ID, instruction, prefix);
endfunction: display

function void UI_Inst_Transaction::post_randomize();
    instruction = {imm, rd, opcode};
endfunction

function UI_Inst_Transaction UI_Inst_Transaction::copy();
    UI_Inst_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.opcode = this.opcode;
    Transaction_Copy.rd = this.rd;
    Transaction_Copy.imm = this.imm;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy    
`endif
