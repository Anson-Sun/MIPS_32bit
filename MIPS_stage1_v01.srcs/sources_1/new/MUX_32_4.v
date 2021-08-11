`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 20:42:57
// Design Name: 
// Module Name: MUX_32_4
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


module MUX_32_4(s,a,b,c,d,out);
    input [31:0]a,b,c,d;
    input [1:0]s;
    output reg [31:0]out;
    always @(*)begin
    if(s==2'b00)
        out = a;
    else if(s==2'b01)
        out = b;
    else if(s==2'b10)
        out = c;
    else if(s==2'b11)
        out = d;
    end
endmodule
