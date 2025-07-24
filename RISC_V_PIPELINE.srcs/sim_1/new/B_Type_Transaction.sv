`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 09:50:43 AM
// Design Name: 
// Module Name: B_Type_Transaction
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

`ifndef B_TRANSACTION
`define B_TRANSACTION
class B_Type_Transaction;
    //property declaration
    int ID;
    bit [6:0] opcode;
    rand bit [4:0] rs1, rs2;
    rand bit [2:0] funct3;
    rand bit [11:0] imm;
    bit [31:0] instruction;
    
    //adding constraint
    constraint funct3_cstr {
        !(funct3 inside {3'b010, 3'b011});
    };
    
    //method prototype
    extern function new(int ID, bit [6:0] opcode = 7'b1100011);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function B_Type_Transaction copy();
endclass: B_Type_Transaction

function B_Type_Transaction::new(int ID, bit [6:0] opcode = 7'b1100011);
    this.ID = ID;
    this.opcode = opcode;
endfunction: new
    
function void B_Type_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %d| Instruction: %b| Status: %s", $time, ID, instruction, prefix);
endfunction: display

function void B_Type_Transaction::post_randomize();
    instruction = {imm[11:5], rs2, rs1, imm[4:0], opcode};
endfunction

function B_Type_Transaction B_Type_Transaction::copy();
    B_Type_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.rs1 = this.rs1;
    Transaction_Copy.rs2 = this.rs2;
    Transaction_Copy.funct3 = this.funct3;
    Transaction_Copy.imm = this.imm;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy    
`endif
