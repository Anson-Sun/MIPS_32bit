`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 20:45:44
// Design Name: 
// Module Name: ForwardingUnit_4
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


module ForwardingUnit_4 (rs,rt,EXE_MEM_RegWr,EXE_MEM_Rd,MEM_WB_Rd,MEM_WB_RegWr,stage_6_Rd,stage_6_RegWr,forwardA,forwardB);

    input [4:0]rs;
    input [4:0]rt;
    
    input      EXE_MEM_RegWr;
    input [4:0]EXE_MEM_Rd;

    input [4:0]MEM_WB_Rd;
    input      MEM_WB_RegWr;

    input [4:0]stage_6_Rd;
    input      stage_6_RegWr;

    output reg [1:0]forwardA;
    output reg [1:0]forwardB;
    
    initial begin
        forwardA=2'b00;
        forwardB=2'b00;
    end

    always@(*)begin
        if(EXE_MEM_RegWr && EXE_MEM_Rd != 1'b0 && EXE_MEM_Rd == rs)
            forwardA=2'b10;
            else begin
                 if (MEM_WB_RegWr && MEM_WB_Rd != 1'b0 && MEM_WB_Rd == rs)
                    forwardA=2'b01;
                    else if(stage_6_RegWr && stage_6_Rd != 1'b0 && stage_6_Rd == rs)
                            forwardA=2'b11;
                            else
                                forwardA=2'b00;
            end
    end
    
    always@(*)begin
        if(EXE_MEM_RegWr && EXE_MEM_Rd != 1'b0 && EXE_MEM_Rd == rt)
            forwardB=2'b10;
            else begin
                 if (MEM_WB_RegWr && MEM_WB_Rd != 1'b0 && MEM_WB_Rd == rt)
                    forwardB=2'b01;
                    else if(stage_6_RegWr && stage_6_Rd != 1'b0 && stage_6_Rd == rt)
                            forwardB=2'b11;
                            else
                                forwardB=2'b00;
            end
    end

endmodule  //ForwardingUnit
