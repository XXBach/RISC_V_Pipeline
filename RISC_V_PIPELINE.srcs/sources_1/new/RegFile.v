`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 09:34:16 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile#(
    parameter DATA_WIDTH = 32,
    parameter REGFILE_DEPTH = 32
)(
    input wire clk,
    input wire reset,
    input wire wen,
    input wire [$clog2(REGFILE_DEPTH) - 1:0] addr_r_0,
    input wire [$clog2(REGFILE_DEPTH) - 1:0] addr_r_1,
    input wire [$clog2(REGFILE_DEPTH) - 1:0] addr_w,
    input wire [DATA_WIDTH - 1:0] data_w,
    output wire [DATA_WIDTH - 1:0] data_r_0,
    output wire [DATA_WIDTH - 1:0] data_r_1
    );
    reg [DATA_WIDTH - 1:0] mem [0:REGFILE_DEPTH - 1];
    always@(posedge clk) begin
        if(wen == 1 && addr_w != 0) mem[addr_w] <= data_w;
        else if(wen == 1 && addr_w == 0) mem[addr_w] <= 0;
    end
    assign data_r_0 = (reset == 1) ? 0 : addr_r_0;
    assign data_r_1 = (reset == 1) ? 0 : addr_r_1;
    
    task dump_mem_to_file();
        integer fd;
        integer i;
        begin
            fd = $fopen("REGFILE_expose.mem", "w");
            if (fd == 0) begin
                $display("ERROR: Cannot open file REGFILE_expose.mem for writing!");
                $finish;
            end
            for (i = 0; i < REGFILE_DEPTH; i = i + 1) begin
                $fdisplay(fd, "%b", mem[i]);  // write in binary format
            end
            $fclose(fd);
            $display("Memory dumped to REGFILE_expose.mem successfully.");
        end
    endtask
endmodule
