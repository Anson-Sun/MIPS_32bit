`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/05 14:54:05
// Design Name: 
// Module Name: HarzardDetectionUnit
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


module HarzardDetectionUnit(stage_RF_ins,stage_EXE_Rt,stage_EXE_memRead,
                            stage_IF_PCwrite,stage_RF_IDwrite,
                            stage_RF_enableD_next_stage_controls);
    
    input [31:0]stage_RF_ins;

    input [4:0]stage_EXE_Rt;
    input      stage_EXE_memRead;
    
    output reg stage_IF_PCwrite;
    output reg stage_RF_IDwrite;
    output reg stage_RF_enableD_next_stage_controls;
    
    wire [4:0]rs,rt;

    assign rs=stage_RF_ins[25:21];
    assign rt=stage_RF_ins[20:16];
    
    always @(*) begin
        if(     (stage_EXE_memRead)
            &&  (
                    (stage_EXE_Rt == rs)
                ||  (stage_EXE_Rt == rt)
            )
            &&  (stage_EXE_Rt != 1'b0)
        )
        begin
            stage_IF_PCwrite=1'b0;
            stage_RF_IDwrite=1'b0;
            stage_RF_enableD_next_stage_controls=1'b0;
        end
        else begin
            stage_IF_PCwrite=1'b1;
            stage_RF_IDwrite=1'b1;
            stage_RF_enableD_next_stage_controls=1'b1;
        end
    end
    
endmodule
