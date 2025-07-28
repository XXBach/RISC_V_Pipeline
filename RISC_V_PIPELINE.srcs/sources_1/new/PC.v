`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:24:38 PM
// Design Name: 
// Module Name: PC
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


module PC#(
    parameter ADDR_WIDTH = 32     
)(
    input wire clk,
    input wire reset,
    input wire loaded,
    input wire [ADDR_WIDTH - 1:0] Next_Addr,
    output reg [ADDR_WIDTH - 1:0] Current_Addr
    );
    always@(posedge clk or posedge reset) begin
        if(reset) Current_Addr = 0;
        else begin
            if(!loaded) Current_Addr = Current_Addr;
            else Current_Addr = Next_Addr;
        end
    end
endmodule
