`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2025 04:34:05 PM
// Design Name: 
// Module Name: Main_Controller
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


module Main_Controller#(
    parameter INSTRUCTION_WIDTH = 32
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [INSTRUCTION_WIDTH - 1:0] instruction,
    output reg [2:0] ImmSel,
    output reg RegWEn,
    output reg BrUn,
    output reg is_Br,
    output reg ASel,
    output reg BSel,
    output reg is_ALU,
    output reg MemRW,
    output reg [1:0] WBSel 
    );
    wire [6:0]opcode;
    wire [2:0]funct3;
    reg is_U;
    reg [3:0] current_state;
    reg [3:0] next_state;
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    initial begin
        current_state = 4'b0000;
        next_state = 4'b0000; 
        if(( opcode == 7'b0010011 && funct3 == 3'b011 ) || ( opcode == 7'b0000011 && funct3 > 3'b011 ) || ( opcode == 7'b1100011 && funct3 > 3'b101 )) is_U = 1'b1;
        else is_U = 1'b0;
    end  
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            current_state <= 4'b0000;
            ImmSel <= 3'b000;
            RegWEn <= 1'b0;
            BrUn <= 1'b0;
            is_Br <= 1'b0;
            ASel <= 1'b0;
            BSel <= 1'b0;
            is_ALU <= 1'b0;
            MemRW <= 1'b0;
            WBSel <= 2'b00;
        end
        else current_state <= next_state;
    end
     
    always @(*) begin
        case (current_state)
            4'b0000: begin
                case (opcode)
                    7'b0110011: begin
                        if(start) next_state = 4'b0001; // R-type
                        else next_state = 4'b0000;
                    end
                    7'b0010011: begin
                        if((funct3 == 3'b001 || funct3 == 3'b101) && start == 1'b1) next_state = 4'b0001; 
                        else if ((funct3 != 3'b001 || funct3 != 3'b101) && start == 1'b1) next_state = is_U ? 4'b0011 : 4'b0010; // I-type (ALU)
                        else next_state = 4'b0000;
                    end
                    7'b0110111: begin 
                        if(start) next_state = 4'b0100; // LUI
                        else next_state = 4'b0000;
                    end
                    7'b0010111: begin
                        if(start) next_state = 4'b0101; // AUIPC
                        else next_state = 4'b0000;
                    end
                    7'b1101111: begin 
                        if(start) next_state = 4'b0110; // JAL
                        else next_state = 4'b0000;
                    end
                    7'b1100111: begin
                        if(start) next_state = 4'b0111; // JALR
                        else next_state = 4'b0000;
                    end
                    7'b0100011: begin
                        if(start) next_state = 4'b1000; // STORE
                        else next_state = 4'b0000;
                    end
                    7'b0000011: begin
                        if(start) next_state = is_U ? 4'b1010 : 4'b1001; // LOAD (signed vs unsigned)
                        else next_state = 4'b0000;
                    end
                    7'b1100011: begin
                        if(start) next_state = is_U ? 4'b1100 : 4'b1011; // BRANCH (signed vs unsigned)
                        else next_state = 4'b0000;
                    end
                    default:next_state = 4'b0000;
                endcase
            end
            4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111,
            4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101: 
            begin
                case (opcode)
                    7'b0110011: next_state = 4'b0001; // R-type
                    7'b0010011: begin
                        if(funct3 == 3'b001 || funct3 == 3'b101) next_state = 4'b0001; 
                        else next_state = is_U ? 4'b0011 : 4'b0010; // I-type (ALU)
                    end
                    7'b0110111: next_state = 4'b0100; // LUI
                    7'b0010111: next_state = 4'b0101; // AUIPC
                    7'b1101111: next_state = 4'b0110; // JAL
                    7'b1100111: next_state = 4'b0111; // JALR
                    7'b0100011: next_state = 4'b1000; // STORE
                    7'b0000011: next_state = is_U ? 4'b1010 : 4'b1001; // LOAD (signed vs unsigned)
                    7'b1100011: next_state = is_U ? 4'b1100 : 4'b1011; // BRANCH (signed vs unsigned)
                    default:next_state = 4'b0000;
                endcase
            end
            default: next_state = 4'b0000; // hoặc giữ lại current_state nếu muốn
        endcase
    end

    always@(current_state) begin
        case(current_state) 
            4'b0001: begin //R-Type
                ImmSel <= 3'b000;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b0;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b01;
            end
            4'b0010: begin //I-Type calculating Instructions signed
                ImmSel <= 3'b000;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b01;
            end
            4'b0011: begin //I-Type calculating Instructions unsigned
                ImmSel <= 3'b001;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b01;
            end
            4'b0100: begin // LUI
                ImmSel <= 3'b100;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b01;
            end
            4'b0101: begin //AUIPC
                ImmSel <= 3'b100;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b1;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b01;
            end
            4'b0110: begin //JAL
                ImmSel <= 3'b101;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b1;
                ASel <= 1'b1;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b10;
            end
            4'b0111: begin //JALR
                ImmSel <= 3'b000;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b1;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b10;
            end
            4'b1000: begin //STORE
                ImmSel <= 3'b010;
                RegWEn <= 1'b0;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b1;
                WBSel <= 2'b00;
            end
            4'b1001: begin // LOAD 
                ImmSel <= 3'b000;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b00;
            end
            4'b1010: begin // LOAD unsigned
                ImmSel <= 3'b001;
                RegWEn <= 1'b1;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b1;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b00;
            end
            4'b1011: begin // Branch Signed
                ImmSel <= 3'b011;
                RegWEn <= 1'b0;
                BrUn <= 1'b0;
                is_Br <= 1'b1;
                ASel <= 1'b0;
                BSel <= 1'b0;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b00;
            end
            4'b1100: begin // Branch unsigned
                ImmSel <= 3'b011;
                RegWEn <= 1'b0;
                BrUn <= 1'b1;
                is_Br <= 1'b1;
                ASel <= 1'b0;
                BSel <= 1'b0;
                is_ALU <= 1'b1;
                MemRW <= 1'b0;
                WBSel <= 2'b00;
            end
            default: begin
                ImmSel <= 3'b000;
                RegWEn <= 1'b0;
                BrUn <= 1'b0;
                is_Br <= 1'b0;
                ASel <= 1'b0;
                BSel <= 1'b0;
                is_ALU <= 1'b0;
                MemRW <= 1'b0;
                WBSel <= 2'b00;
            end           
        endcase
    end
endmodule
