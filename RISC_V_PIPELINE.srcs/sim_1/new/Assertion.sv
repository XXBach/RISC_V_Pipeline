`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 10:23:49 AM
// Design Name: 
// Module Name: Assertion
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


class Assertion;
    string name;
    virtual RISCV_IO.Assertion rsc_io;
    
    extern function new(string name = "Assertion", virtual RISCV_IO.Assertion rsc_io);
    extern task running_assertion();
    extern function fatal_errors();
    extern function IF_ID_errors();
endclass: Assertion
    function Assertion::new(string name, virtual RISCV_IO.Assertion rsc_io);
        this.name = name;
        this.rsc_io = rsc_io;
    endfunction: new
    
    task Assertion::running_assertion();
        
    endtask: running_assertion;
    function Assertion::fatal_errors();
        parameter IMEM_DEPTH = 1024;
        parameter DATA_WIDTH = 32;
        parameter REGFILE_DEPTH = 32;
        logic [DATA_WIDTH-1:0] mem [0:IMEM_DEPTH-1];
        logic [DATA_WIDTH-1:0] reg_mem[0:REGFILE_DEPTH-1];
        int fd;
        int i = 0;
        $readmemb("IMEM_expose.mem",mem);
        foreach(mem[i]) begin
            if (^mem[i] === 1'bx) begin  // ^: reduction XOR, detect unknown bits
                $fatal(1, "[%0t] INSTRUCTION MEMORY CHECK FAILED: Unknown (x/z) values found in %s", $time, "IMEM_expose");
            end
        end
        $display("[%0t] INSTRUCTION MEMORY CHECK SUCCESSFUL", $time);
        i = 0;
        $readmemb("REGFILE_expose.mem",reg_mem);
        foreach(reg_mem[i]) begin
            if (^reg_mem[i] === 1'bx) begin  // ^: reduction XOR, detect unknown bits
                $fatal(1, "[%0t] INSTRUCTION MEMORY CHECK FAILED: Unknown (x/z) values found in %s", $time, "IMEM_expose");
            end
        end
        $display("[%0t] INSTRUCTION MEMORY CHECK SUCCESSFUL", $time);
    endfunction:fatal_errors
    function Assertion::IF_ID_errors();
        
    endfunction:IF_ID_errors