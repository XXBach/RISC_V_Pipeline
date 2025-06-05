`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 09:44:38 AM
// Design Name: 
// Module Name: JALR_Inst_Transaction
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


class JALR_Inst_Transaction;
    //property declaration
    int ID;
    bit [6:0] opcode;
    rand bit [4:0] rd, rs1;
    bit [2:0] funct3;
    bit [11:0] imm;
    bit [31:0] instruction;
    //adding constraint
    
    //method prototype
    extern function new(int ID, bit [6:0] opcode = 7'b1100111, funct3 = 3'b000);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function JALR_Inst_Transaction copy();
endclass: JALR_Inst_Transaction

function JALR_Inst_Transaction::new(int ID, bit [6:0] opcode = 7'b1100111, funct3 = 3'b000);
    this.ID = ID;
    this.opcode = opcode;
    this.funct3 = funct3;
endfunction: new
    
function void JALR_Inst_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %i| Instruction: %b| Status: %s", $time, ID, Instruction, prefix);
endfunction: display

function void JALR_Inst_Transaction::post_randomize();
    instruction = {imm, rs1, funct3, rd, opcode};
endfunction

function JALR_Inst_Transaction JALR_Inst_Transaction::copy();
    JALR_Inst_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.rd = this.rd;
    Transaction_Copy.rs1 = this.rs1;
    Transaction_Copy.imm = this.imm;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy 
