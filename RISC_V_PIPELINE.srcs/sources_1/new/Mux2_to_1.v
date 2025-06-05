`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:41:29 PM
// Design Name: 
// Module Name: Mux2_to_1
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


module Mux2_to_1#(
    parameter DATA_WIDTH = 32
)(
    input wire Sel,
    input wire [DATA_WIDTH - 1:0] A,
    input wire [DATA_WIDTH - 1:0] B,
    output reg [DATA_WIDTH - 1:0] C
    );
    always@(*) begin
        if(Sel) C = B;
        else C = A;
    end
endmodule
