`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/25 09:10:06
// Design Name: 
// Module Name: GPR
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


module GPR(clk,RegWr,Rw,Data,Ra,Rb,A,B,show);

    //RegWr?§Õ????
     input RegWr,clk;
    //RegWr?1???????????? ??Data????Rw????? 
    input [4:0]Rw,Ra,Rb;
    input [31:0]Data;
    //A??B??????Ra??Rb???????????
    output [31:0]A,B;
    output [31:0]show;
    //32??32¦Ë??¨¹????
    reg [31:0]GPR[0:31];
    integer i;
    initial begin
    for(i = 0;i<=31;i = i + 1)
    begin
        GPR[i] = 0;
    end
    end
    //??????
    assign A=GPR[Ra];
    assign B=GPR[Rb];
    assign show=GPR[3][31:0];
    //0????¨¹????????
    initial begin
       GPR[0]=0;
    end
    
    //§Õ????
    //?????? ????§¹
    always @(posedge clk ) begin
        if (RegWr && Rw ) begin
            GPR[Rw] <= Data;
        end
    end

endmodule
