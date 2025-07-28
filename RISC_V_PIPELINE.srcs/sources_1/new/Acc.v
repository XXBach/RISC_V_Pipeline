`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:44:36 PM
// Design Name: 
// Module Name: Acc
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


module Acc#(
    parameter DATA_WIDTH = 32
)(
    input wire loaded,
    input wire [DATA_WIDTH - 1:0] data_in,
    output reg [DATA_WIDTH - 1:0] accumulated_data
    );
    always@(*) begin
        if(!loaded) accumulated_data = data_in;
        else accumulated_data = data_in + 1;
    end
endmodule
