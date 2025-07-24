`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/27/2025 03:45:57 PM
// Design Name: 
// Module Name: RISCV_test
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
`include "Generator.sv"
`include "Agent.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Checker.sv"
`include "Assertion.sv"
program automatic RISCV_test(RISCV_IO.Test RSCV_io);
    int run_for_n_instructions;    
    
    Driver drvr;
    Monitor mntr;
    Generator gen;
    Agent code_file_gen;
    Checker check;
    Assertion srt;
    
    
    initial begin 
        run_for_n_instructions = 100;
        gen = new("GEN", run_for_n_instructions);
        code_file_gen = new("AGENT", gen.out_box);
        drvr = new("DRIVER", RSCV_io);
        mntr = new("MONITOR", RSCV_io, run_for_n_instructions);
        check = new("CHECKER", run_for_n_instructions, mntr.out_box);
        srt = new("ASSERTION", RSCV_io);
        
        gen.start();
        code_file_gen.makefile("instruction0.mem");
        drvr.Start(run_for_n_instructions);
        mntr.Start();
        check.checking();
        srt.running_assertion();
    end
endprogram: RISCV_test
