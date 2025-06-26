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
typedef mailbox #(RISCV_OUTPUTS) OPS_mbox;
class Checker;
    string name;
    int run_for_n_instructions;
    OPS_mbox in_box = new();
    
    extern function new(string name ="Checker", int run_for_n_instructions = 64, OPS_mbox in_box = null);
    extern function void checking();
    extern function bit is_success (RISCV_OUTPUTS OP2T, logic [31:0] IMem [0:1023], logic [31:0] Reg_mem[0:31], logic [31:0] Dmem [0:65535], bit [$clog2(1024) - 1: 0] IMem_address);
    extern function void display(RISCV_OUTPUTS OP2T, bit mode);
endclass:Checker
    function Checker::new(string name, int run_for_n_instructions, RISCV_OUTPUTS in_box);
        this.name = name;
        this.run_for_n_instructions = run_for_n_instructions;
        this.in_box = in_box;
    endfunction:new
    function void Checker::checking();
//        this.status = 2'b01;
        RISCV_OUTPUTS OP2T = new(0);
        logic [31:0] mem [0:1023];
        logic [31:0] reg_mem[0:31];
        logic [31:0] dmem [0:65535];
        bit [$clog2(1024) - 1: 0] IMem_address;
        bit checking_1_inst;
        bit display_mode = 0;
        bit [6:0] opcode = OP2T.instruction[6:0];
        bit [2:0] funct3 = OP2T.instruction[14:12];
        $readmemb("IMEM_expose.mem",mem);
        $readmemb("REGFILE_expose.mem",reg_mem);
        $readmemb("DMEM_expose.mem",dmem);
        forever begin
            in_box.try_get(OP2T);
            if(OP2T.Current_PC == IMem_address) begin
                checking_1_inst = this.is_success(OP2T, mem, reg_mem, dmem, IMem_address);
                if(checking_1_inst == null) break;
                else if (!checking_1_inst) begin
                    if(opcode == 7'b1100011) IMem_address += 1; 
                    else $error(1, "[%0t] Check fail with instruction: %b", $time, OP2T.instruction);
                end
                else begin
                    if(opcode == 7'b0110011 || opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b1100111 || opcode == 7'b0110111 || opcode == 7'b0010111) begin
                        reg_mem[OP2T.instruction[11:7]] = OP2T.WB_Result;
                        if(opcode == 7'b1100111) IMem_address = OP2T.ALU_Result;
                        else IMem_address += 1;
                    end
                    else if(opcode == 7'b0100011) begin
                        logic [31:0] A = reg_mem[OP2T.instruction[19:15]];
                        logic [31:0] imm = {{21{OP2T.instruction[31]}}, OP2T.instruction[30:25], OP2T.instruction[11:7]};
                        logic [31:0] Data;
                        if(funct3 == 3'b000) Data = {24'b0, OP2T.WB_Result[7:0]};
                        else if(funct3 == 3'b001) Data = {16'b0, OP2T.WB_Result[15:0]};
                        else if(funct3 == 3'b010) Data = OP2T.WB_Result;
                        dmem[A + imm] = Data;
                        IMem_address += 1;
                    end
                    else if (opcode == 7'b1100011 || opcode == 7'b1101111) IMem_address = OP2T.ALU_Result;
                end
            end
            else begin
                $display ("[%0t] Mismatch PC - Expected PC: %d - Instruction PC: %d", $time, IMem_address, OP2T.Current_PC); 
                break;
            end
        end
    endfunction:checking
    function bit Checker::is_success(RISCV_OUTPUTS OP2T, logic [31:0] IMem [0:1023], logic [31:0] Reg_mem[0:31], logic [31:0] Dmem [0:65535], bit [$clog2(1024) - 1: 0] IMem_address);
        bit display_mode = 0;
        bit [6:0] opcode = OP2T.instruction[6:0];
        bit [2:0] funct3 = OP2T.instruction[14:12];
        if(OP2T.instruction != IMem[IMem_address]) begin
            $display("[%0t] instruction doesn't match, Receive instruction: %b, Expected instruction: %b", $time, OP2T.instruction, IMem[IMem_address]);
            return 0;
        end
        if(opcode == 7'b0110011 || (opcode == 7'b0010011 && (funct3 == 001 || funct3 == 101))) begin
            logic [6:0] funct7 = OP2T.instruction[31:25];
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] B = Reg_mem[OP2T.instruction[24:20]];
            logic [31:0] C;
            if(funct7 != 7'b0000000 && funct7 != 7'b0100000) begin
                $display("[%0t] funct7 doesn't exist: %b, fail instruction: %b", $time, OP2T.instruction[31:25], OP2T.instruction);
                return 0;
            end
            case(funct3)
                3'b000: begin
                    if(funct7 == 7'b0000000) C = A + B;
                    else C = A - B;
                end
                3'b001: C = A << B;
                3'b010: C = ($signed(A) < $signed(B)) ? 1 : 0;
                3'b011: C = (A < B) ? 1 : 0;
                3'b100: C = A ^ B;
                3'b101: begin
                    if(funct7 == 7'b0000000) C = A >> B;
                    else C = A >>> B;
                end
                3'b110: C = A | B;
                3'b111: C = A & B;
            endcase
            if(OP2T.data_r_0 != A || OP2T.data_r_1 != B || OP2T.ALU_Result != C || OP2T.WB_Output != C) begin
                return 0;
            end
            else begin
                return 1;
            end 
        end
        else if(opcode == 7'b0010011 && (funct3 != 001 && funct3 != 101)) begin
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] B = {{21{OP2T.instruction[31]}}, OP2T.instruction[30:20]};
            logic [31:0] C;
            case(funct3)
                3'b000: C = A + B;
                3'b010: C = ($signed(A) < $signed(B)) ? 1 : 0;
                3'b011: C = (A < B) ? 1 : 0;
                3'b100: C = A ^ B;
                3'b110: C = A | B;
                3'b111: C = A & B;
            endcase
            if(OP2T.data_r_0 != A || OP2T.imm_out != B || OP2T.ALU_Result != C || OP2T.WB_Output != C) begin
                return 0;
            end
            else begin
                return 1;
            end 
        end
        else if(opcode == 7'b0100011) begin
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] B = Reg_mem[OP2T.instruction[24:20]];
            logic [31:0] imm = {{21{OP2T.instruction[31]}}, OP2T.instruction[30:25], OP2T.instruction[11:7]};
            logic [31:0] Data;
            if(OP2T.data_r_0 == A && OP2T.data_r_1 == B && OP2T.ALU_Result == A + imm && OP2T.imm_out == imm) begin
                if(funct3 == 3'b000) Data = {24'b0, B[7:0]};
                else if(funct3 == 3'b001) Data = {16'b0, B[15:0]};
                else if(funct3 == 3'b010) Data = B;
                if(OP2T.WB_Result != Data) begin
                    return 0;
                end
                else begin
                    return 1;
                end 
            end
            else begin
                return 0;
            end
        end
        else if(opcode == 7'b0000011) begin
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] B = Reg_mem[OP2T.instruction[12:9]];
            logic [31:0] imm = {{21{OP2T.instruction[31]}}, OP2T.instruction[30:20]};
            logic [31:0] Data = Dmem[A + imm];
            if(OP2T.data_r_0 == A && OP2T.data_r_1 == B && OP2T.imm_out == imm) begin
                if(funct3 == 3'b000 || funct3 == 3'b100) begin
                    Data = {24'b0, Data[7:0]};
                end
                else if(funct3 == 3'b001 || funct3 == 3'b101) begin
                    Data = {16'b0, Data[15:0]};
                end
                if(OP2T.WB_Result != Data) begin
                    return 0;
                end
                else begin
                    return 1;
                end 
            end
            else begin
                return 1;
            end
        end
        else if(opcode == 7'b1100011) begin
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] B = Reg_mem[OP2T.instruction[24:20]];
            logic [31:0] imm = {{20{OP2T.instruction[31]}}, OP2T.instruction[7], OP2T.instruction[30:25], OP2T.instruction[11:8], 1'b0};
            if(OP2T.data_r_0 == A && OP2T.data_r_1 == B && OP2T.imm_out == imm) begin
                if(funct3 == 3'b000) begin
                    if(A == B) return 1;
                    else return 0;
                end
                else if(funct3 == 3'b001) begin
                    if(A != B) return 1;
                    else return 0;
                end
                else if(funct3 == 3'b100 || funct3 == 3'b110) begin
                    if(funct3 == 3'b100) begin
                        if($signed(A) < $signed(B)) return 1;
                        else return 0; 
                    end
                    else begin
                        if(A < B) return 1;
                        else return 0; 
                    end
                end
                else if(funct3 == 3'b101 || funct3 == 3'b111) begin
                   if(funct3 == 3'b100) begin
                        if($signed(A) >= $signed(B)) return 1;
                        else return 0; 
                    end
                    else begin
                        if(A >= B) return 1;
                        else return 0; 
                    end
                end
            end
            else begin
                $fatal(1, "[%0t] Branch check fail with instruction: %b", $time, OP2T.instruction);
                return 0;
            end
        end
        else if(opcode == 7'b1100111) begin
            logic [31:0] A = Reg_mem[OP2T.instruction[19:15]];
            logic [31:0] imm = {{21{OP2T.instruction[31]}}, OP2T.instruction[30:20]};
            logic [31:0] C = A + imm;
            if(OP2T.data_r_0 == A && OP2T.imm_out == imm && OP2T.ALU_Result == C && OP2T.WB_Result == OP2T.Current_PC + 1) begin
                if(funct3 == 3'b000) return 1;
                else return 0;         
            end
            else begin
                $fatal(1, "[%0t] Branch check fail with instruction: %b", $time, OP2T.instruction);
                return 0;
            end
        end
        else if(opcode == 7'b1101111) begin
            logic [31:0] imm = {{12{OP2T.instruction[31]}}, OP2T.instruction[19:12], OP2T.instruction[20], OP2T.instruction[30:25], OP2T.instruction[24:21], 1'b0};
            logic [31:0] C = OP2T.Current_PC + imm;
            if(OP2T.imm_out == imm && OP2T.ALU_Result == C && OP2T.WB_Result == OP2T.Current_PC + 1) return 1;
            else begin
                $fatal(1, "[%0t] Branch check fail with instruction: %b", $time, OP2T.instruction);
                return 0;
            end
        end
        else if(opcode == 7'b0110111 || opcode == 7'b0010111) begin
            logic [31:0] A = OP2T.Current_PC;
            logic [31:0] imm = {OP2T.instruction[31:12], 12'h000};
            logic [31:0] C = A + imm;
            if(OP2T.imm_out == imm && OP2T.ALU_Result == C && OP2T.WB_Result == C) return 1;         
            else begin
                $fatal(1, "[%0t] Branch check fail with instruction: %b", $time, OP2T.instruction);
                return 0;
            end
        end
    endfunction: is_success
    function void Checker::display(RISCV_OUTPUTS OP2T, bit mode);
        if(!mode) begin
            $display("[%0t] Instruction fail: %b", $time, OP2T.instruction);
            $display("Expected data: data_r_0: %d | data_r_1: %d | ALU_Result: %d | WB_Result: %d", A, B, C, C);
            $display("Received data: data_r_0: %d | data_r_1: %d | ALU_Result: %d | WB_Result: %d", OP2T.data_r_0, OP2T.data_r_1, OP2T.ALU_Result, OP2T.WB_Output);
        end
        else begin
            $display("[%0t] Instruction Success: %b", $time, OP2T.instruction);
        end
    endfunction:display