`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 09:12:24 PM
// Design Name: 
// Module Name: J_Type_Transaction
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


class J_Type_Transaction;
    //property declaration
    int ID;
    bit [6:0] opcode;
    rand bit [4:0] rd;
    rand bit [19:0] imm;
    bit [31:0] instruction;
    //adding constraint
    
    //method prototype
    extern function new(int ID, bit [6:0] opcode = 7'b1101111);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function J_Type_Transaction copy();
endclass: J_Type_Transaction

function J_Type_Transaction::new(int ID, bit [6:0] opcode = 7'b1101111);
    this.ID = ID;
    this.opcode = opcode;
endfunction: new
    
function void J_Type_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %i| Instruction: %b| Status: %s", $time, ID, Instruction, prefix);
endfunction: display

function void J_Type_Transaction::post_randomize();
    instruction = {imm, rd, opcode};
endfunction

function J_Type_Transaction J_Type_Transaction::copy();
    J_Type_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.rd = this.rd;
    Transaction_Copy.imm = this.imm;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy 
