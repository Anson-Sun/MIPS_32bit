`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/25 10:57:32
// Design Name: 
// Module Name: datapath
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


module datapath(reset,clk,RegDst,RegWr,memWr,memtoDst,op,func,Zero, sw,display_data );

    input reset,clk,RegDst,RegWr,memWr,memtoDst;
    
    input [15:0]sw;
    output Zero;
    output [5:0]op,func; 
    output reg [31:0]display_data=32'b0;
    
    wire [4:0]rs,rt,rd,Rw;
    wire [15:0]imm;
    wire [31:0]ins,A,B,data,ALU_result,Mem_out,current_PC,next_PC;
    wire Flush_Pipeline;
    
    reg [31:0]seg_displaydata;
    reg [4:0] stage_RF_new_writeport = 0 ;
    
    wire [31:0]stage_IF_current_PC, stage_IF_ins;
    reg [31:0]stage_IF_next_PC= 0 ; 
    wire stage_RF_RegWr,stage_RF_memWr,stage_RF_memRead,stage_RF_memtoReg; 
    wire  [4:0]stage_RF_Rd, stage_RF_Rs, stage_RF_Rt;
    wire [31:0]stage_RF_A, stage_RF_B;
    reg [31:0]stage_RF_current_PC=0 ; 
    reg [31:0]stage_RF_ins=32'b0;
    wire [4:0]stage_RF_Rw;
    wire stage_RF_RegDst;    
    wire [5:0]stage_RF_op;
    wire [5:0]stage_RF_func;
    
    reg stage_WB_RegWr = 1'b0;  // from stage : write back
	reg [4:0]stage_WB_Rd = 5'b0;
	wire [31:0]stage_WB_memtoReg_result;
    
    wire  [31:0] stage_EXE_next_PC;
    
    //stage1 IF
     PC_32         u_PC         (clk,reset,stage_IF_current_PC,stage_IF_next_PC);
    INS_MEM   u_instmem    (stage_IF_current_PC , stage_IF_ins);
    always@(*)begin
        if(Flush_Pipeline==1'b0)
            stage_IF_next_PC = stage_IF_current_PC+4;
        else
            stage_IF_next_PC=stage_EXE_next_PC;
    end
    always @(posedge clk ) begin
        $display("datapath.v line 60: %d %x %x" , $time ,  stage_IF_current_PC, stage_IF_ins) ;
    end
    //stage2 RF
    always @(posedge clk) begin
        stage_RF_current_PC  <= stage_IF_current_PC;
        if(Flush_Pipeline==1'b0)
        begin
		   stage_RF_ins <= stage_IF_ins; 
		end
		else
		begin
		    stage_RF_ins <= 0; 
		end
  	end
 
    /*assign stage_RF_RegDst=RegDst    ;
    assign stage_RF_RegWr =RegWr;
    assign stage_RF_memWr = memWr ;
    assign stage_RF_memtoReg=memtoDst;*/
    assign stage_RF_Rd  = stage_RF_ins[15:11] ; // stage_IF_ins[15:11] ;
    assign stage_RF_Rs  = stage_RF_ins[25:21] ; // stage_IF_ins[25:21];
    assign stage_RF_Rt  = stage_RF_ins[20:16] ; // stage_IF_ins[20:16];	
    assign stage_RF_op=stage_RF_ins[31:26];
    assign stage_RF_func=stage_RF_ins[5:0];
   
    MUX_5_2   u_RegDst       (stage_RF_RegDst, stage_RF_Rt, stage_RF_Rd, stage_RF_Rw);

    always @(*)begin
        if(stage_RF_ins[31:26]==6'b000011)
            stage_RF_new_writeport=5'd31;
        else
            stage_RF_new_writeport=stage_RF_Rw;
    end
    GPR     u_gpr          (clk,stage_WB_RegWr , stage_WB_Rd, stage_WB_memtoReg_result, stage_RF_Rs, stage_RF_Rt, stage_RF_A, stage_RF_B);
    control u_control(stage_RF_op,stage_RF_func,Zero,extOp,stage_RF_RegDst,stage_RF_RegWr,stage_RF_memWr,stage_RF_memtoReg,pcsource);
    //extOp and pcsource are not used
    //Zero is from alu
    
    //stage3 EXE
    reg stage_EXE_RegWr = 1'b0;
	reg [4:0]stage_EXE_Rd = 5'b0;
	
	reg stage_EXE_memtoReg = 1'b0;
	
	reg stage_EXE_memRead  = 1'b0;
    reg stage_EXE_memWr = 1'b0;
   
	reg [31:0]stage_EXE_current_PC  =0; 
	reg [31:0]stage_EXE_ins = 32'b0;
	
	reg [31:0]stage_EXE_A = 32'b0;
	reg [31:0]stage_EXE_B = 32'b0;
    
    wire  [31:0] stage_EXE_ALU_result ; 
    
    always @(posedge clk ) begin
        stage_EXE_current_PC <= stage_RF_current_PC;
		    stage_EXE_RegWr <= stage_RF_RegWr;
            stage_EXE_Rd <= stage_RF_new_writeport;
            stage_EXE_memtoReg <= stage_RF_memtoReg ;
            stage_EXE_memRead <= stage_RF_memRead ;
            stage_EXE_memWr <= stage_RF_memWr ;
            stage_EXE_ins <= stage_RF_ins;
            stage_EXE_A <= stage_RF_A;
            stage_EXE_B <= stage_RF_B;
    end	
    
    ALU    u_alu          (stage_EXE_ins, stage_EXE_ALU_result, stage_EXE_A, stage_EXE_B, Zero, stage_EXE_current_PC, stage_EXE_next_PC,Flush_Pipeline);
    
    //stage4 MEM
     reg stage_MEM_RegWr = 1'b0;
	reg [4:0]stage_MEM_Rd = 5'b0;
	reg stage_MEM_memtoReg  = 1'b0;
	reg [31:0]stage_MEM_ALU_result = 32'b0;
    reg stage_MEM_memWr = 1'b0;
	reg [31:0]stage_MEM_B = 32'b0;
	reg [31:0]stage_MEM_ins=0;
	
	
	always @(posedge clk) begin
		    stage_MEM_RegWr  <= stage_EXE_RegWr;
		    stage_MEM_Rd <= stage_EXE_Rd;
	        stage_MEM_memtoReg <= stage_EXE_memtoReg;
            stage_MEM_ALU_result <= stage_EXE_ALU_result;
            stage_MEM_memWr <= stage_EXE_memWr;
            stage_MEM_B <= stage_EXE_B;
            stage_MEM_ins<=	stage_EXE_ins;
	end
	
	wire  [31:0] stage_MEM_mem_data_out;
    
     DATA_MEM   u_datamem    (clk, stage_MEM_memWr,stage_MEM_ALU_result ,stage_MEM_B , sw, stage_MEM_mem_data_out);
    
    always @(posedge clk ) begin
       if( stage_MEM_memWr == 1 && stage_MEM_ALU_result==32'h10000000)begin//&& stage_MEM_ins[31:26]==6'b101011
            display_data <= stage_MEM_B[31:0] ;
        end
    end
    always @(posedge clk ) begin
       if(stage_MEM_memWr==1 && stage_MEM_ALU_result==32'h10000010)begin//stage_MEM_ins[31:26]==6'b101011 && 
             seg_displaydata<= stage_MEM_B[31:0] ;
        end
    end
    
    //stage5 WB
    reg stage_WB_memtoReg = 0; 
    reg [31:0]stage_WB_ALU_result = 0;
	reg [31:0]stage_WB_mem_data_out = 0 ;
	reg [31:0] stage_WB_ins = 0 ;
	
	always @(posedge clk) begin
		    stage_WB_RegWr <= stage_MEM_RegWr;
		    stage_WB_Rd <= stage_MEM_Rd;
		    stage_WB_ins  <= stage_MEM_ins ;
		    stage_WB_memtoReg <= stage_MEM_memtoReg;
	        stage_WB_ALU_result <= stage_MEM_ALU_result;
	        stage_WB_mem_data_out <= stage_MEM_mem_data_out;
	end

    MUX_32_2  u_memtodst     (stage_WB_memtoReg  , stage_WB_ALU_result, stage_WB_mem_data_out, stage_WB_memtoReg_result);
	
endmodule
