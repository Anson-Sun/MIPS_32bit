`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/07 10:21:26
// Design Name: 
// Module Name: MUX_1_2
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


module MUX_1_2(s,a,b,c);
input a,b;
    input s;
    output reg c;
    always @(*)begin
    if(s==1'b0)
        c=a;
        else 
           c=b;
    end
endmodule
