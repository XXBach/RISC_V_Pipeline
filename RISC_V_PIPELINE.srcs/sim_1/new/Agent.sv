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
    int run_for_n_instructions;
    Instr_mbox in_box;
    bit status;
    
    extern function new(string name = "Agent", Instr_mbox in_box, int run_for_n_instructions);
    extern task makefile(string filename = "instruction0.mem");
    extern function void display();
endclass:Agent

function Agent::new(string name, Instr_mbox in_box, int run_for_n_instructions);
    this.name = name;
    this.in_box = in_box;
    this.run_for_n_instructions = run_for_n_instructions;
endfunction: new
    
function void Agent::display();
    if(status) $display("[%0t] Making instruction file....", $time);
    else $display ("[%0t] Waiting....", $time);
endfunction: display
    
task Agent::makefile(string filename);
    int filedesc;
    instr instruction_to_file;
    this.status = 0;
    this.display();
    filedesc = $fopen(filename,"w");
    if(filedesc == 0) begin
        $display("[%0t] Cannot open file: %s", $time, filename);
        return;
    end    
    for(int i = 0; i <= this.run_for_n_instructions; i++) begin
        this.in_box.get(instruction_to_file);
        this.status = 1;
        $fdisplay(filedesc,"%b",instruction_to_file.instruction);
    end    
    $display("[%0t] Instructions successfully saved to file: %s", $time, filename);
    $fclose(filedesc);  
endtask: makefile

`endif