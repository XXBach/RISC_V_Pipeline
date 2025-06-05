`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 10:18:05 AM
// Design Name: 
// Module Name: Checker
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

typedef class RISCV_OUTPUTS;
`include"Monitor.sv"
typedef enum int {
    R_Type = 0,
    I_Type = 1,
    S_Type = 2,
    J_Type = 3,
    B_Type = 4,
    UI_Instr = 5,
    JALR = 6
} instr_num;
class Checker;
    string name;
    int run_for_n_instructions;
    bit [1:0] status;
    RISCV_OUTPUTS in_box = new(0);
    
    extern function new(string name ="Checker", int run_for_n_instructions = 64, RISCV_OUTPUTS in_box = null);
    extern task checking();
    extern function void display(logic [31:0] instruction);
endclass:Checker
    function Checker::new(string name, int run_for_n_instructions, RISCV_OUTPUTS in_box);
        this.name = name;
        this.run_for_n_instructions = run_for_n_instructions;
        this.in_box = in_box;
        this.status = 2'b00;
    endfunction:new
    task Checker::checking();
//        this.status = 2'b01;
        RISCV_OUTPUTS OP2T = new(0);
        logic [31:0] mem [0:1023];
        logic [31:0] reg_mem[0:31];
        logic [31:0] dmem [0:65535];
        $readmemb("IMEM_expose.mem",mem);
        $readmemb("REGFILE_expose.mem",reg_mem);
        $readmemb("DMEM_expose.mem",dmem);
        for(int i = 0; i <= this.run_for_n_instructions; i++) begin
            in_box.try_get(OP2T);
            
            this.status = 2'b01;
        end
    endtask:checking
    function void Checker::display(logic [31:0] instruction);
        if(this.status == 2'b00) $display("[%0t] Checker's waiting ...", $time);
        else if(this.status == 2'b01) $display("[%0t] Checker's checking ....", $time);
        else if(this.status == 2'b10) $display("[%0t] Checked failed for instruction: %b", $time, instruction);
        else $display("[%0t] Checked success for instruction: %b", $time, instruction);
    endfunction:display