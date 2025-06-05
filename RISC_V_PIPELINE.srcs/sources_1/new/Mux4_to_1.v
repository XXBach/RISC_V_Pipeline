`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2025 03:04:05 PM
// Design Name: 
// Module Name: Mux4_to_1
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


module Mux4_to_1#(
    parameter DATA_WIDTH = 32
)(
    input wire [1:0] Sel,
    input wire [DATA_WIDTH - 1:0] A,
    input wire [DATA_WIDTH - 1:0] B,
    input wire [DATA_WIDTH - 1:0] C,
    input wire [DATA_WIDTH - 1:0] D,
    output reg [DATA_WIDTH - 1:0] E
    );
    always@(*) begin
        case(Sel) 
            2'b00: E = A;
            2'b01: E = B;
            2'b10: E = C;
            2'b11: E = D;
        endcase
    end
endmodule
