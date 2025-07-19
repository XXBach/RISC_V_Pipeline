`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 09:22:50 AM
// Design Name: 
// Module Name: Driver
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
typedef class instr;
class Driver;
    virtual RISCV_IO.Test rsc_io;
    string name;
    bit [1:0] status;
    
    extern function new(string name = "Driver", virtual RISCV_IO.Test rsc_io = null);
    extern task Start(int run_for_n_instructions);
    extern function void display();
endclass: Driver
    function Driver::new(string name, virtual RISCV_IO.Test rsc_io);
        this.name = name;
        this.rsc_io = rsc_io;
    endfunction: new
    
    
    task Driver::Start(int run_for_n_instructions);
        //Phase 1: Reset
        rsc_io.reset = 0;
        rsc_io.RISCV_cb.start = 0;
        rsc_io.RISCV_cb.IMem_Start = 0;
        this.status = 0;
        this.display();
        @(posedge rsc_io.RISCV_cb);
        rsc_io.reset = 1;
        this.status = 1;
        this.display();
        repeat(100) @(negedge rsc_io.RISCV_cb);
        rsc_io.reset = 0;
        //Phase 2: Nap lenh
        rsc_io.RISCV_cb.IMem_Start = 1;
        this.status = 2;
        this.display();
        repeat(20) @(negedge rsc_io.RISCV_cb);
        rsc_io.RISCV_cb.IMem_Start = 0;
        //Phase 3: Run
        rsc_io.RISCV_cb.start = 1;
        this.status = 3;
        this.display();
        repeat(run_for_n_instructions) @(posedge rsc_io.RISCV_cb);
        rsc_io.RISCV_cb.start = 0;
    endtask: Start;
    
    function void Driver::display();
        if(this.status == 2'b00) $display("[%0t] Driver is waiting......");
        else if(this.status == 2'b01) $display("[%0t] Reset RISC_V Processor......");
        else if(this.status == 2'b10) $display("[%0t] Loading Instructions to RISC_V processor ......");
        else $display("[%0t] Running ......");
    endfunction: display