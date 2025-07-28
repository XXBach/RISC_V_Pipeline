`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 10:01:17 AM
// Design Name: 
// Module Name: I_Type_Transaction
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

`ifndef I_TRANSACTION
`define I_TRANSACTION
class I_Type_Transaction;
    //property declaration
    int ID;
    rand bit [6:0] opcode, funct7;
    rand bit [4:0] rs1, rd, shamt;
    rand bit [2:0] funct3;
    rand bit [11:0] imm;
    bit [31:0] instruction;
    
    //adding constraint
    constraint opcode_cstr {
        opcode inside {7'b0010011, 7'b0000011};
    };
    constraint funct3_cstr {
         (opcode == 7'b0000011) -> funct3 inside {3'b000, 3'b001, 3'b010, 3'b100, 3'b101};
         (opcode == 7'b0010011) -> funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111};
    };
    constraint funct7_cstr {
        !(funct7 inside {7'b0000000, 7'b0100000});
    };
    
    //method prototype
    extern function new(int ID);
    extern function void display (string prefix = "NOTE");
    extern function void post_randomize();
    extern function I_Type_Transaction copy();
endclass: I_Type_Transaction

function I_Type_Transaction::new(int ID);
    this.ID = ID;
endfunction: new
    
function void I_Type_Transaction::display(string prefix);
    $display("[%0t] Transaction_ID: %d| Instruction: %b| Status: %s", $time, ID, instruction, prefix);
endfunction: display

function void I_Type_Transaction::post_randomize();
    if(opcode == 7'b0010011 && (funct3 == 001 || funct3 == 101)) 
        instruction = {funct7, shamt, rs1, funct3, rd, opcode};
    else instruction = {imm[11:0], rs1, funct3, rd, opcode};
endfunction

function I_Type_Transaction I_Type_Transaction::copy();
    I_Type_Transaction Transaction_Copy;
    Transaction_Copy = new(this.ID);
    Transaction_Copy.opcode = this.opcode;
    Transaction_Copy.rs1 = this.rs1;
    Transaction_Copy.rd = this.rd;
    Transaction_Copy.shamt = this.shamt;
    Transaction_Copy.funct3 = this.funct3;
    Transaction_Copy.funct7 = this.funct7;
    Transaction_Copy.imm = this.imm;
    Transaction_Copy.instruction = this.instruction;
endfunction: copy    
`endif