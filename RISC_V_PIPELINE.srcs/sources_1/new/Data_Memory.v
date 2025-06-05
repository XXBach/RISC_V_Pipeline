`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 08:49:18 PM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory#(
    parameter DATA_WIDTH = 32,
    parameter DMEM_DEPTH = 65536
)(
    input wire clk,
    input wire reset,
    input wire MemRW,
    input wire [DATA_WIDTH - 1:0] DataW,
    input wire [$clog2(DMEM_DEPTH) - 1:0] Addr,
    output reg [DATA_WIDTH - 1:0] DataR
    );
    reg [DATA_WIDTH - 1:0] mem [0:DMEM_DEPTH - 1];
    always@(posedge clk or negedge reset) begin
        if(!reset) begin
            DataR <= 0;
        end
        else begin
            if(MemRW)DataR <= mem[Addr];
            else mem[Addr] <= DataW;
        end
    end
    task dump_mem_to_file();
        integer fd;
        integer i;
        begin
            fd = $fopen("DMEM_expose.mem", "w");
            if (fd == 0) begin
                $display("ERROR: Cannot open file %s for writing!", filename);
                $finish;
            end
            for (i = 0; i < DMEM_DEPTH; i = i + 1) begin
                $fdisplay(fd, "%b", mem[i]);  // write in binary format
            end
            $fclose(fd);
            $display("Memory dumped to %s successfully.", filename);
        end
    endtask
endmodule
