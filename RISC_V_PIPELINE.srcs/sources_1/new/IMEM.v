`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:46:46 PM
// Design Name: 
// Module Name: IMEM
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


module IMEM#(
    parameter INSTRUCTION_WIDTH = 32,
    parameter IMEM_LENGTH = 65536
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [$clog2(IMEM_LENGTH) - 1:0] addr,
    output reg [INSTRUCTION_WIDTH - 1:0] instruction,
    output reg is_loaded
);
    reg [INSTRUCTION_WIDTH - 1:0] mem [0:IMEM_LENGTH - 1];
    reg loaded;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 0;
            loaded <= 0;
            is_loaded <= 0;
        end
        else if (start && !loaded) begin
            $display("[%0t] Reloading instruction0.mem", $time);
            $readmemb("D:/Sem2Year3/Redemption/RISC_V_PIPELINE/RISC_V_PIPELINE.sim/sim_1/behav/xsim/instruction0.mem", mem);
            loaded <= 1;
            is_loaded <= 0;
        end
        else if (!start) begin
            loaded <= 0; // reset flag để lần sau start lên lại load
            is_loaded <= 0;
        end
        else begin
            instruction <= mem[addr];
            is_loaded <= 1;
        end
    end
    
    task dump_mem_to_file();
        integer fd;
        integer i;
        begin
            fd = $fopen("IMEM_expose.mem", "w");
            if (fd == 0) begin
                $display("ERROR: Cannot open file IMEM_expose.mem for writing!");
                $finish;
            end

            for (i = 0; i < IMEM_LENGTH; i = i + 1) begin
                $fdisplay(fd, "%b", mem[i]);  // write in binary format
            end

            $fclose(fd);
            $display("Memory dumped to IMEM_expose.mem successfully.");
        end
    endtask
endmodule

