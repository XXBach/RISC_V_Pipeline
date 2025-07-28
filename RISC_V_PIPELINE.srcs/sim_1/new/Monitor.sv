`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2025 09:51:27 AM
// Design Name: 
// Module Name: Monitor
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

`ifndef MONITOR_OUTPUT_INFO
`define MONITOR_OUTPUT_INFO
typedef class RISCV_OUTPUTS;
typedef mailbox #(RISCV_OUTPUTS) OPS_mbox; 
class Monitor;
    virtual RISCV_IO.Test rsc_io;
    event start_e;
    string name;
    bit [1:0] status;
    int run_for_n_instructions;
    OPS_mbox out_box = new();
    
    extern function new(string name = "Monitor", virtual RISCV_IO.Test rsc_io = null, int run_for_n_instructions, event start_e);
    extern task Start();
    extern function void display();
endclass: Monitor
    function Monitor::new(string name, virtual RISCV_IO.Test rsc_io, int run_for_n_instructions, event start_e);
        this.name = name;
        this.rsc_io = rsc_io;
        this.run_for_n_instructions = run_for_n_instructions;
        this.start_e = start_e;
    endfunction: new
    
    task Monitor::Start();
        logic [15:0] PC2P[$];
        logic [31:0] instruction2P[$];
        logic [31:0] data_r_0_2P[$];
        logic [31:0] data_r_1_2P[$];
        logic [31:0] imm_out2P[$];
        logic [31:0] ALU_Result_2P[$];
        logic [31:0] WB_Output_2P[$];
        RISCV_OUTPUTS opt = new(0);
        RISCV_OUTPUTS opt2C;
        
        @(this.start_e);
        @(rsc_io.RISCV_cb);
        PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
        instruction2P.push_front(rsc_io.RISCV_cb.instruction);
        this.status = 2'b00;
        this.display();
        @(rsc_io.RISCV_cb);
        PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
        instruction2P.push_front(rsc_io.RISCV_cb.instruction);
        data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
        data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
        imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
        this.status = 2'b01;
        this.display();
        @(rsc_io.RISCV_cb);
        PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
        instruction2P.push_front(rsc_io.RISCV_cb.instruction);
        data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
        data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
        imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
        ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
        this.status = 2'b10;
        this.display();
        @(rsc_io.RISCV_cb);
        PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
        instruction2P.push_front(rsc_io.RISCV_cb.instruction);
        data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
        data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
        imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
        ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
        @(rsc_io.RISCV_cb);
        PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
        instruction2P.push_front(rsc_io.RISCV_cb.instruction);
        data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
        data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
        imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
        ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
        WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
        for(int i = 4; i < this.run_for_n_instructions; i++) begin
            @(rsc_io.RISCV_cb);
            PC2P.push_front(rsc_io.RISCV_cb.Current_PC);
            instruction2P.push_front(rsc_io.RISCV_cb.instruction);
            data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
            data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
            imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
            ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
            WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
            this.status = 2'b11;
            this.display();
        end
        @(rsc_io.RISCV_cb);
        data_r_0_2P.push_front(rsc_io.RISCV_cb.data_r_0);
        data_r_1_2P.push_front(rsc_io.RISCV_cb.data_r_1);
        imm_out2P.push_front(rsc_io.RISCV_cb.imm_out);
        ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
        WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
        @(rsc_io.RISCV_cb);
        ALU_Result_2P.push_front(rsc_io.RISCV_cb.ALU_Result);
        WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
        @(rsc_io.RISCV_cb);
        WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
        this.status = 2'b01;
        this.display();
        @(rsc_io.RISCV_cb);
        WB_Output_2P.push_front(rsc_io.RISCV_cb.WB_Output);
        this.status = 2'b00;
        this.display();
        
        for(int j = 0; j <= this.run_for_n_instructions; j++) begin
            opt.ID = j;
            opt.Current_PC = PC2P.pop_back();
            opt.instruction = instruction2P.pop_back();
            opt.data_r_0 = data_r_0_2P.pop_back();
            opt.data_r_1 = data_r_1_2P.pop_back();
            opt.imm_out = imm_out2P.pop_back();
            opt.ALU_Result = ALU_Result_2P.pop_back();
            opt.WB_Output = WB_Output_2P.pop_back();
            opt2C = new(j);
            opt2C = opt.copy();
            opt2C.display();
            out_box.put(opt2C);
        end
    endtask: Start
    
    function void Monitor::display();
        if(this.status == 2'b00) $display("[%0t] Saving Current PC: %d and Instruction: %b......", $time, rsc_io.RISCV_cb.Current_PC, rsc_io.RISCV_cb.instruction);
        else if(this.status == 2'b01) $display("[%0t] Saving Data Read 0: %d, Data Read 1: %d and Immediate: %d......", $time, rsc_io.RISCV_cb.data_r_0, rsc_io.RISCV_cb.data_r_1, rsc_io.RISCV_cb.imm_out);
        else if(this.status == 2'b10) $display("[%0t] Saving ALU Result: %d", $time, rsc_io.RISCV_cb.ALU_Result);
        else $display("[%0t] Saving Write Back Output", $time, rsc_io.RISCV_cb.WB_Output);
    endfunction: display
    
    
/////////////////////////////////////////////////////////////////////////////////////////////
class RISCV_OUTPUTS;
    int ID;
    logic [15:0] Current_PC;
    logic [31:0] instruction;
    logic [31:0] data_r_0;
    logic [31:0] data_r_1;
    logic [31:0] imm_out;
    logic [31:0] ALU_Result;
    logic [31:0] WB_Output;
    extern function new(int ID);
    extern function void display ();
    extern function RISCV_OUTPUTS copy ();
endclass: RISCV_OUTPUTS
    
    function RISCV_OUTPUTS::new(int ID);
        this.ID = ID;
    endfunction: new
    
    function void RISCV_OUTPUTS::display();
        $display("[%0t] Instruction number: %d | PC: %h | Instruction bin: %b | Data read 0: %d | Data read 1: %d | Immediate: %d | Calculated Result: %d | Write Back data: %b", 
                    $time, ID, Current_PC, instruction, data_r_0, data_r_1, imm_out, ALU_Result, WB_Output);
    endfunction: display
    
    function RISCV_OUTPUTS RISCV_OUTPUTS::copy();
        RISCV_OUTPUTS OP2C = new(this.ID);
        OP2C.Current_PC = this.Current_PC;
        OP2C.instruction = this.instruction;
        OP2C.data_r_0 = this.data_r_0;
        OP2C.data_r_1 = this.data_r_1;
        OP2C.imm_out = this.imm_out;
        OP2C.ALU_Result = this.ALU_Result;
        OP2C.WB_Output = this.WB_Output;
        return OP2C;
    endfunction: copy
`endif