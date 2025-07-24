`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 11:05:30 AM
// Design Name: 
// Module Name: Generator
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
`ifndef GEN_INST_INFO
`define GEN_INST_INFO
typedef class instr;
typedef class Instr_TYPE;
`include "I_Type_Transaction.sv"
`include "B_Type_Transaction.sv"
`include "J_Type_Transaction.sv"
`include "S_Type_Transaction.sv"
`include "R_Type_Transaction.sv"
`include "UI_Inst_Transaction.sv"
`include "JALR_Inst_Transaction.sv"

typedef enum int {
    R_Type = 0,
    I_Type = 1,
    S_Type = 2,
    J_Type = 3,
    B_Type = 4,
    UI_Instr = 5,
    JALR = 6
} instr_num;
typedef mailbox #(instr) Instr_mbox;
class Generator;
    string name;
    int run_for_n_instructions;
    bit status = 0;
    Instr_TYPE instruction_Type = new(0,5,5,0,0,0,0,0);
    Instr_mbox out_box;
    
    extern function new (string name = "GEN", int run_for_n_instructions = 1024);
    extern task start ();
    extern function void display (int instruction_n);
endclass: Generator

function Generator::new(string name, int run_for_n_instructions);
    this.name = name;
    this.run_for_n_instructions = run_for_n_instructions;
endfunction: new

function void Generator::display(int instruction_n);
    if(status) $display("[%0t] Generation finished successfully with %d instructions", $time, run_for_n_instructions);
    else $display("[%0t] Generating.... | Completed: %d | Instruction amounts require: %d", $time, instruction_n, run_for_n_instructions); 
endfunction: display

task Generator::start();
    out_box = new(run_for_n_instructions);
    for(int i = 0; i <= run_for_n_instructions; i++) begin
        if(i == run_for_n_instructions) status = 1;
        else status = 0;
        this.display(i);
        instruction_Type.ID = i;
        assert(instruction_Type.randomize());
        instruction_Type.display("success");
        case(instruction_Type.instr_Type)
            0: begin
                R_Type_Transaction R_Transact;
                instr instruction;
                instr instr_mb;
                R_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                R_Transact.randomize();
                instruction = new(i,R_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            1: begin
                I_Type_Transaction I_Transact;
                instr instruction;
                instr instr_mb;
                I_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                I_Transact.randomize();
                instruction = new(i,I_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            2: begin
                S_Type_Transaction S_Transact;
                instr instruction;
                instr instr_mb;
                S_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                S_Transact.randomize();
                instruction = new(i,S_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            3: begin
                B_Type_Transaction B_Transact;
                instr instruction;
                instr instr_mb;
                B_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                B_Transact.randomize();
                instruction = new(i,B_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            4: begin
                J_Type_Transaction J_Transact;
                instr instruction;
                instr instr_mb;
                J_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                J_Transact.randomize();
                instruction = new(i,J_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            5: begin
                UI_Inst_Transaction UI_Transact;
                instr instruction;
                instr instr_mb;
                UI_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                UI_Transact.randomize();
                instruction = new(i,UI_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            6: begin
                JALR_Inst_Transaction JALR_Transact;
                instr instruction;
                instr instr_mb;
                JALR_Transact = new(i);
                instr_mb = new(0,0,instruction_Type.instr_Type); 
                JALR_Transact.randomize();
                instruction = new(i,JALR_Transact.instruction, instruction_Type.instr_Type);
                instr_mb = instruction.copy();
                out_box.put(instr_mb);               
            end
            default: begin
                status = 0;
                this.display(i);
                break;
            end
        endcase
    end
endtask: start

//////////////////////////////////////////////////////////////////////////////////////////////////
class Instr_TYPE;
    int ID;
    rand instr_num instr_Type;
    int R_wt, I_wt, J_wt, S_wt, B_wt, UI_wt, JALR_wt;
    
    constraint generate_dist_cstr{
    instr_Type dist {R_Type := R_wt,
                     I_Type := I_wt,
                     J_Type := J_wt,
                     S_Type := S_wt,
                     B_Type := B_wt,
                     UI_Instr := UI_wt,
                     JALR := JALR_wt};
    };
    extern function new (int ID, int R_wt, int I_wt, int J_wt, int S_wt, int B_wt, int UI_wt, int JALR_wt);
    extern function void display ( string prefix );
    extern function Instr_TYPE copy();
endclass: Instr_TYPE

function Instr_TYPE::new(int ID, int R_wt, int I_wt, int J_wt, int S_wt, int B_wt, int UI_wt, int JALR_wt);
    this.ID = ID;
    this.R_wt = R_wt;
    this.I_wt = I_wt;
    this.J_wt = J_wt;
    this.S_wt = S_wt;
    this.B_wt = B_wt;
    this.UI_wt = UI_wt;
    this.JALR_wt = JALR_wt;
endfunction: new

function void Instr_TYPE::display(string prefix);
    $display("Instruction type decided at time: [%0t]| Instruction number: %d| Instruction type: %d", $time, ID, instr_Type); 
endfunction: display

function Instr_TYPE Instr_TYPE::copy();
    Instr_TYPE Type2C = new(this.ID, this.R_wt, this.I_wt, this.J_wt, this.S_wt, this.B_wt, this.UI_wt, this.JALR_wt);
    Type2C.instr_Type = this.instr_Type;
    Type2C.R_wt = this.R_wt;
    Type2C.I_wt = this.I_wt;
    Type2C.J_wt = this.J_wt;
    Type2C.S_wt = this.S_wt;
    Type2C.B_wt = this.B_wt;
    Type2C.UI_wt = this.UI_wt;
    Type2C.JALR_wt = this.JALR_wt;
    return Type2C;
endfunction:copy

///////////////////////////////////////////////////////////////////////////////////////////
class instr;
    int ID;
    instr_num instr_Type;
    bit [31:0] instruction;
    function new(int ID = 0,bit [31:0] instruction = 0, instr_num instr_Type);
        this.ID = ID;
        this.instr_Type = instr_Type;
        this.instruction = instruction;
    endfunction: new
    function instr copy();
        instr i2C = new(this.ID, this.instruction, this.instr_Type);
        return i2C;
    endfunction: copy
endclass: instr
`endif
