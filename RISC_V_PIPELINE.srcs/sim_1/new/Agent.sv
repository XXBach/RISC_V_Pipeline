`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 08:38:35 AM
// Design Name: 
// Module Name: Agent
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
`ifndef AGENT
`define AGENT
`include "Generator.sv"
class Agent;
    string name;
    Instr_mbox in_box;
    bit status;
    
    extern function new(string name = "Agent", Instr_mbox in_box);
    extern function void makefile(string filename = "instruction0.mem");
    extern function void display();
endclass:Agent

function Agent::new(string name, Instr_mbox in_box);
    this.name = name;
    this.in_box = in_box;
endfunction: new
    
function void Agent::display();
    if(status) $display("[%0t] Making instruction file....", $time);
    else $display ("[%0t] Waiting....", $time);
endfunction: display
    
function void Agent::makefile(string filename);
    int filedesc;
    instr instruction_to_file;
    int count = 0;
    this.status = 0;
    filedesc = $fopen(filename,"w");
    if(filedesc == 0) begin
        $display("[%0t] Cannot open file: %s", $time, filename);
        return;
    end    
    while (this.in_box.try_get(instruction_to_file)) begin
        this.status = 1;
        $fdisplay(filedesc,"%b",instruction_to_file.instruction);
        count++;
    end    
    $display("[%0t] Instructions successfully saved to file: %s", $time, filename);
    $fclose(filedesc);
endfunction: makefile

`endif