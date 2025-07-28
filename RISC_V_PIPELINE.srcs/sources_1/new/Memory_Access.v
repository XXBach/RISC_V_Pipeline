`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 03:09:21 PM
// Design Name: 
// Module Name: Memory_Access
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


module Memory_Access#(
    parameter DATA_WIDTH = 32,
    parameter DMEM_DEPTH = 1024
)(
    input wire clk,
    input wire reset,
    input wire MemRW,
    input wire [1:0] WBSel,
    input wire [DATA_WIDTH - 1:0] ExeResult,
    input wire [DATA_WIDTH - 1:0] PC4,
    input wire [DATA_WIDTH - 1:0] DataW,
    output wire [DATA_WIDTH - 1:0] DataWb    
    );
    wire [DATA_WIDTH - 1:0] DataR;
    Data_Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .DMEM_DEPTH(DMEM_DEPTH)
    )DMEM(
        .clk(clk),
        .reset(reset),
        .MemRW(MemRW),
        .DataW(DataW),
        .Addr(ExeResult),
        .DataR(DataR)
    );
    reg [DATA_WIDTH - 1:0] ExeResult_WB;
    reg [DATA_WIDTH - 1:0] PC4_WB;
    reg [DATA_WIDTH - 1:0] DataR_WB;
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            ExeResult_WB <= 0;
            PC4_WB <= 0;
            DataR_WB <= 0;
        end
        else begin
            ExeResult_WB <= ExeResult;
            PC4_WB <= PC4;
            DataR_WB <= DataR;
        end
    end
    Mux4_to_1#(
        .DATA_WIDTH(DATA_WIDTH)
    )WBMux(
        .Sel(WBSel),
        .A(DataR_WB),
        .B(ExeResult_WB),
        .C(PC4_WB),
        .D(0),
        .E(DataWb)
    );
endmodule
