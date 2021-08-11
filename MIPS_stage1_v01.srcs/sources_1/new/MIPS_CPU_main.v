`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 11:08:07
// Design Name: 
// Module Name: MIPS_CPU_main
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


module MIPS_CPU_datapath(
         input request,
         input             reset,
		 input             clk  ,
		 input     [15:0]  sw,
		 output reg[31:0]  display_data,
		 output reg[31:0]  seg_displaydata
		 );
    
    wire RegDst,RegWr,memWr,memtoDst;
    
    wire Zero;
    reg [5:0]op,func; 
    
    wire [4:0]rs,rt,rd,Rw;
    wire [15:0]imm;
    // this ins in not used��just FW
    // so this ins is deleted by Hhc
    wire [31:0]A,B,data,ALU_result,Mem_out,current_PC,next_PC;
    wire Flush_Pipeline;
    
    reg [4:0] stage_ID_new_writeport = 0 ;
    
    wire [31:0]stage_IF_current_PC, stage_IF_ins;
    reg [31:0]stage_IF_next_PC= 0 ; 
    wire stage_ID_RegWr,stage_ID_memWr,stage_ID_memRead,stage_ID_memtoReg; 

    wire  [4:0]stage_ID_Rd, stage_ID_Rs, stage_ID_Rt;
    wire [31:0]stage_ID_A, stage_ID_B;
    reg [31:0]stage_ID_current_PC=0 ; 
    reg [31:0]stage_ID_ins=32'b0;
    wire [4:0]stage_ID_Rw;
    wire stage_ID_RegDst;    
    wire [5:0]stage_ID_op;
    wire [5:0]stage_ID_func;
    
    reg stage_WB_RegWr = 1'b0;  // from stage : write back
	reg [4:0]stage_WB_Rd = 5'b0;
	wire [31:0]stage_WB_memtoReg_result;
    
    wire  [31:0] stage_EXE_next_PC;
    //forwarding_unit
    wire [1:0]forwardA;
	wire [1:0]forwardB;
	wire [31:0]forwardA_result;
	wire [31:0]forwardB_result;
	//HarzardDetecting_unit
	wire stage_IF_PCwrite;
    wire stage_ID_IDwrite;
    wire stage_ID_enableD_next_stage_controls;
    wire harzard_muxout;
    wire stage_ID_di;
    wire stage_ID_ei;
    wire signal_eret;
    wire signal_syscall;
    wire [31:0]sepc_address;
    wire [8:0]stage_ID_ins_ID;
    reg [8:0]stage_EXE_ins_ID=0;
    //interrupt
    wire stage_ID_syscall;
    wire stage_ID_eret;
    wire stage_ID_mfc0,stage_ID_mtc0,stage_ID_Break;
    wire [31:0]show;
    reg [31:0]HI,LO=32'b0;
    wire[31:0]data_HI,data_LO;
    
    //stage1 IF
     PC_32         u_PC         (clk,reset,stage_IF_current_PC,stage_IF_next_PC,stage_IF_PCwrite);
    INS_MEM   u_instmem    (stage_IF_current_PC , stage_IF_ins);
    always@(*)begin
            if(Flush_Pipeline==1'b0)
                stage_IF_next_PC = stage_IF_current_PC+4;
            else
                stage_IF_next_PC=stage_EXE_next_PC;
                $display("if_next %x",stage_EXE_next_PC);
    end
    //stage2 ID
    always @(posedge clk) begin
        stage_ID_current_PC  <= stage_IF_current_PC;
        if(Flush_Pipeline==1'b0)
        begin
            if(stage_ID_IDwrite==1'b1)
		      stage_ID_ins <= stage_IF_ins; 
		      else
		          stage_ID_ins <= stage_ID_ins;
		end
		else
		begin
		    stage_ID_ins <= 0; 
		end
  	end
 
    assign stage_ID_Rs  = stage_ID_ins[25:21] ; // stage_IF_ins[25:21];
    assign stage_ID_Rt  = stage_ID_ins[20:16] ; // stage_IF_ins[20:16];	
    assign stage_ID_Rd  = stage_ID_ins[15:11] ; // stage_IF_ins[15:11] ;
    assign stage_ID_op  = stage_ID_ins[31:26];
    assign stage_ID_func= stage_ID_ins[5:0];
   
    MUX_5_2   u_RegDst       (stage_ID_RegDst, stage_ID_Rt, stage_ID_Rd, stage_ID_Rw);

    always @(*)begin
        if(stage_ID_ins[31:26]==6'b000011)
            stage_ID_new_writeport=5'd31;
        else
            stage_ID_new_writeport=stage_ID_Rw;//�̶�jal����31�żĴ���
    end
    GPR     u_gpr          (clk,stage_WB_RegWr , stage_WB_Rd, stage_WB_memtoReg_result, 
                            stage_ID_Rs, stage_ID_Rt, stage_ID_A, stage_ID_B,show);
    control u_control(stage_ID_ins,stage_ID_op,stage_ID_func,Zero,stage_ID_RegDst,
                      stage_ID_RegWr,stage_ID_memRead,stage_ID_memWr,stage_ID_memtoReg,stage_ID_syscall,stage_ID_eret,stage_ID_mfc0,stage_ID_mtc0,stage_ID_Break,stage_ID_di,stage_ID_ei);//�������ûд��? syscall д������
    //extOp and pcsource are not used
    //so extOp and pcsource is deleted by Hhc
    //Zero is from alu
    MUX_1_2 u_mux_harzard(stage_ID_enableD_next_stage_controls,Flush_Pipeline,1'b0,harzard_muxout);
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
	wire hardware_interrupt;
	wire [4:0]exceptioncode;
	
    wire [31:0]mfc0_number;
    wire [31:0]status_number;
    wire  [31:0] stage_EXE_ALU_result ; 

    reg [4:0] stage_EXE_Rt=5'b0;
	reg [4:0] stage_EXE_Rs=5'b0;
	
	//about interrupt
	reg stage_EXE_eret;
    reg stage_EXE_syscall;
    reg stage_EXE_mfc0;
    reg stage_EXE_mtc0;
    reg stage_EXE_Break;
    reg stage_EXE_di;
    reg stage_EXE_ei;
	
	//stage6 forwarding regs
	reg [4:0]stage_6_Rd=5'b0;
	reg stage_6_RegWr=1'b0;
	reg [31:0]stage_6_databack=32'b0;
    
    
    always @(posedge clk ) begin
        if(stage_ID_enableD_next_stage_controls==1'b1)begin
            if(hardware_interrupt)begin
                stage_EXE_current_PC <=32'b00000+32'b101000 ;
                //stage_EXE_current_PC <=32'b00000+32'b0 ;
            end
            else begin
             stage_EXE_current_PC <= stage_ID_current_PC;
            end
            //stage_EXE_current_PC <= stage_ID_current_PC;
            stage_EXE_Rd <= stage_ID_new_writeport;
            if(stage_ID_IDwrite==1'b0)begin
                stage_EXE_RegWr <= stage_ID_RegWr;
                stage_EXE_memtoReg <= stage_ID_memtoReg ;//���if�д�����
            end
            else begin
                stage_EXE_RegWr <= stage_ID_RegWr;
                stage_EXE_memtoReg <= stage_ID_memtoReg ;//
            end
            stage_EXE_memRead <= stage_ID_memRead ;
            stage_EXE_memWr <= stage_ID_memWr ;
            stage_EXE_ins <= stage_ID_ins;
            stage_EXE_A <= stage_ID_A;
            stage_EXE_B <= stage_ID_B;
            stage_EXE_Rt <= stage_ID_Rt;
            stage_EXE_Rs <= stage_ID_Rs;
            // about interrupt
            stage_EXE_mfc0 <=stage_ID_mfc0;
            stage_EXE_mtc0 <=stage_ID_mtc0;
            stage_EXE_Break <=stage_ID_Break;
            stage_EXE_di <=stage_ID_di;
            stage_EXE_ei <=stage_ID_ei;
            stage_EXE_ins_ID <= stage_ID_ins_ID;
            stage_EXE_syscall <= stage_ID_syscall;                         
            stage_EXE_eret <= stage_ID_eret;
            //
        end
        else begin
            stage_EXE_RegWr <= 1'b0;
            stage_EXE_memRead <= 1'b0 ;
            stage_EXE_memWr <= 1'b0 ;
            stage_EXE_syscall <= 1'b0;
            stage_EXE_eret <= 1'b0;
        end
    end	
    
    ALU    u_alu          (hardware_interrupt,request,sepc_address,stage_EXE_ins, stage_EXE_ALU_result, forwardA_result, forwardB_result, 
                           Zero,stage_EXE_current_PC, stage_EXE_next_PC,Flush_Pipeline,exceptioncode,data_HI,data_LO,mfc0_number,status_number);
    
    always @(*)begin
        HI=data_HI;
        LO=data_LO;
    end
    //interruption
    CP0  u_CP0 (
    .clk                     ( clk                        ),
    .mfc0                    (stage_EXE_mfc0),
    .mtc0                    (stage_EXE_mtc0),
    .eret                    ( stage_EXE_eret                       ),
    .syscall                   ( stage_EXE_syscall                     ),
    .rd_EXE(stage_EXE_Rd),
    .rd_ID(stage_ID_Rd),
    .mfc0_number(mfc0_number),
    .request                 ( request                    ),
    .pc_address              ( stage_EXE_ALU_result ),
    .exceptioncode           ( exceptioncode  ),
    .hardware_interrupt      ( hardware_interrupt         ),
    .sepc_address            ( sepc_address        [31:0] ),
    .di(stage_EXE_di),
    .ei(stage_EXE_ei),
    .status_number(status_number)
    );
    always@(*)begin
        if(sw[15]==1)
        begin
            display_data =show;
            seg_displaydata =show;
        end
        else
        begin
            display_data =stage_IF_current_PC;
            seg_displaydata =stage_IF_current_PC;
        end

    end
    //stage4 MEM
     reg stage_MEM_RegWr = 1'b0;
	reg [4:0]stage_MEM_Rd = 5'b0;
	reg stage_MEM_memtoReg  = 1'b0;
	reg [31:0]stage_MEM_ALU_result = 32'b0;
	reg stage_MEM_memRead = 1'b0;
    reg stage_MEM_memWr = 1'b0;
	reg [31:0]stage_MEM_B = 32'b0;
	reg [31:0]stage_MEM_ins=0;
	//interruption
	reg stage_MEM_eret;
    reg stage_MEM_syscall; 
    reg stage_MEM_mfc0,stage_MEM_di,stage_MEM_ei;
    reg [4:0]stage_MEM_Rt;

	always @(posedge clk) begin
		    stage_MEM_RegWr  <= stage_EXE_RegWr;
            if(stage_EXE_mfc0==1 ||stage_EXE_di==1||stage_EXE_ei==1)
            begin
                stage_MEM_Rd <=stage_EXE_Rt;
            end
            else
            begin
                stage_MEM_Rd <= stage_EXE_Rd;
            end

	        stage_MEM_memtoReg <= stage_EXE_memtoReg;
            stage_MEM_ALU_result <= stage_EXE_ALU_result;
            stage_MEM_memRead <= stage_EXE_memRead;
            stage_MEM_memWr <= stage_EXE_memWr;
            stage_MEM_B <= forwardB_result;
            stage_MEM_Rt<=stage_EXE_Rt;
            stage_MEM_ins<=	stage_EXE_ins;
            stage_MEM_mfc0<=stage_EXE_mfc0;
            stage_MEM_di<=stage_EXE_di;
            stage_MEM_ei<=stage_EXE_ei;
            if(hardware_interrupt)begin
                stage_MEM_RegWr <= 1'b0;
                stage_MEM_memRead <= 1'b0 ;
                stage_MEM_memWr <= 1'b0 ;
            end
    end     
    
	            
	wire  [31:0] stage_MEM_mem_data_out;
    
     DATA_MEM   u_datamem    (clk, stage_MEM_memRead,stage_MEM_memWr,stage_MEM_ALU_result ,
                              stage_MEM_B , sw, stage_MEM_mem_data_out);
    
    /*always @(posedge clk ) begin
       *//*if( stage_MEM_memWr == 1 && stage_MEM_ALU_result==32'h10000000)begin
            //&& stage_MEM_ins[31:26]==6'b101011
            display_data <= stage_MEM_B[31:0] ;
        end*//*

    end*/
    /*always @(posedge clk ) begin
       *//*if(stage_MEM_memWr==1 && stage_MEM_ALU_result==32'h10000010)begin
            //stage_MEM_ins[31:26]==6'b101011 && 
             seg_displaydata<= stage_MEM_B[31:0] ;
        end*//*
            seg_displaydata <= stage_IF_current_PC ;
    end*/
    //stage5 WB
    reg stage_WB_memtoReg = 0; 
    reg [31:0]stage_WB_ALU_result = 0;
	reg [31:0]stage_WB_mem_data_out = 0 ;
	reg [31:0] stage_WB_ins = 0 ;
	reg stage_WB_eret;
	reg stage_WB_syscall;
	
	always @(posedge clk) begin
		    stage_WB_RegWr <= stage_MEM_RegWr;
		    stage_WB_Rd <= stage_MEM_Rd;
		    stage_WB_ins  <= stage_MEM_ins ;
		    stage_WB_memtoReg <= stage_MEM_memtoReg;
	        stage_WB_ALU_result <= stage_MEM_ALU_result;
	        stage_WB_mem_data_out <= stage_MEM_mem_data_out;
	end

    MUX_32_2  u_memtodst     (stage_WB_memtoReg  , stage_WB_ALU_result, 
                              stage_WB_mem_data_out, stage_WB_memtoReg_result);
	
	
	//Forwarding
	/*ForwardingUnit u_ForwardingUnit(stage_EXE_Rs,stage_EXE_Rt,stage_MEM_RegWr,stage_MEM_Rd,
	                                stage_WB_Rd,stage_WB_RegWr,forwardA,forwardB);*/
	/*MUX_32_3 u_MUX_forwardA(forwardA,stage_EXE_A,stage_WB_memtoReg_result,
	                        stage_MEM_ALU_result,forwardA_result);
	MUX_32_3 u_MUX_forwardB(forwardB,stage_EXE_B,stage_WB_memtoReg_result,
	                        stage_MEM_ALU_result,forwardB_result);*/
	
	//stage6 
	ForwardingUnit_4 u_ForwardingUnit_4(stage_EXE_Rs,stage_EXE_Rt,stage_MEM_RegWr,stage_MEM_Rd,
	                                stage_WB_Rd,stage_WB_RegWr,stage_6_Rd,stage_6_RegWr,forwardA,forwardB);
	MUX_32_4 u_MUX_forwardA(forwardA,stage_EXE_A,stage_WB_memtoReg_result,
	                       stage_MEM_ALU_result,stage_6_databack,forwardA_result);
	MUX_32_4 u_MUX_forwardB(forwardB,stage_EXE_B,stage_WB_memtoReg_result,
	                        stage_MEM_ALU_result,stage_6_databack,forwardB_result);
	always@(posedge clk)begin
	   stage_6_Rd <= stage_WB_Rd;
	   stage_6_RegWr <= stage_WB_RegWr;
	   stage_6_databack <= stage_WB_memtoReg_result;
	end

	// CP0  u_CP0 (clk,stage_EXE_eret,stage_EXE_syscall,request,stage_EXE_ALU_result,exceptioncode,hardware_interrupt,sepc_address);
	//HarzardDetection
	HarzardDetectionUnit u_hazard_detection(stage_ID_ins,stage_EXE_Rt,stage_EXE_memRead,
                            stage_IF_PCwrite,stage_ID_IDwrite,
                            stage_ID_enableD_next_stage_controls);
endmodule
