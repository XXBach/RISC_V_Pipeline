`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 10:50:46 AM
// Design Name: 
// Module Name: R_Type_Transaction
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

class R_Type_Transaction;
    //property declaration
    int ID;
    bit [6:0] opcode;
    rand bit [4:0] rs1, rs2, rd;
    rand bit [2:0] funct3;
    rand bit [6:0] funct7;
    bit [31:0] instruction;
    //adding constraint
    constraint funct7_cstr {
        funct7 inside {7'b0000000, 7'b0100000};
    };
    
    //method prototype
    extern function new(int ID, bit [6:0] opcode = 7'b0110011);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function R_Type_Transaction copy();
endclass: R_Type_Transaction

function R_Type_Transaction::new(int ID, bit [6:0] opcode = 7'b0110011);
    this.ID = ID;
    this.opcode = opcode;
endfunction: new
    
function void R_Type_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %i| Instruction: %b| Status: %s", $time, ID, Instruction, prefix);
endfunction: display

function void R_Type_Transaction::post_randomize();
    instruction = {funct7, rs2, rs1, funct3, rd, opcode};
endfunction

function R_Type_Transaction R_Type_Transaction::copy();
    R_Type_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.rs1 = this.rs1;
    Transaction_Copy.rs2 = this.rs2;
    Transaction_Copy.rd = this.rd;
    Transaction_Copy.funct3 = this.funct3;
    Transaction_Copy.funct7 = this.funct7;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy    

