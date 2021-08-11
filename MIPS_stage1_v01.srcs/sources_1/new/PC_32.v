`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/23 21:19:20
// Design Name: 
// Module Name: PC_32
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


module PC_32(clk,clr,PC_now,PC_next,stage_IF_PCwrite);

    input clk,clr,stage_IF_PCwrite;
    input [31:0]PC_next;
    output reg [31:0]PC_now=32'h00000000 ; // dj : 32'h00400024;
    
    always @(posedge clk)
    begin
        if(clr==1'b0)
            PC_now<=32'h00000000;
            //PC_now<=32'h00400024;//
            else begin
                if(stage_IF_PCwrite==1'b1)
                    PC_now<=PC_next;
            end
    end
    
endmodule
