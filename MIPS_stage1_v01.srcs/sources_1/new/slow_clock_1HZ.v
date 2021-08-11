`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/20 14:40:05
// Design Name: 
// Module Name: slow_clock_ori
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



module slow_clock_1HZ(clk_in,clk_out,pause);
    input clk_in,pause;
    output reg clk_out=1'b1;
    reg [31:0]clk_count=1'b0;
    always @(posedge clk_in)begin
        if(pause==1'b1)
        begin
            clk_count=clk_count;
        end
        //else if(clk_count==32'd50000000)//12500000
        else if(clk_count==32'd6250000)//12500000
        begin
            clk_out=~clk_out;
            clk_count=1'b1;
        end
        else 
        begin
            clk_count=clk_count+1'b1;
        end
    end
endmodule
