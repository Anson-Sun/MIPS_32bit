`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/24 09:33:16
// Design Name: 
// Module Name: MUX_2
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


module MUX_32_2(s,a,b,c);
    input [31:0]a,b;
    input s;
    output reg [31:0]c;
    always @(*)begin
    if(s==1'b0)
        c=a;
        else 
           c=b;
    end
endmodule
