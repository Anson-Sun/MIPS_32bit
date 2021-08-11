`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 15:15:27
// Design Name: 
// Module Name: MUX_5_3
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


module MUX_32_3(s,a,b,c,out);
    input [31:0]a,b,c;
    input [1:0]s;
    output reg [31:0]out;
    always @(*)begin
    if(s==2'b00)
        out = a;
    else if(s==2'b01)
        out = b;
    else if(s==2'b10)
        out = c;
    end
endmodule
