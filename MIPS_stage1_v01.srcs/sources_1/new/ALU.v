`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 10:41:59
// Design Name: 
// Module Name: ALU
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


module ALU(hardware_interrupt,request,sepc_address,ins, result, A, B, Zero, current_PC,next_PC,Flush_Pipeline,exceptioncode,HI,LO,mfc0_number,status_number);

    input signed [31:0]A,B;
    input [31:0]status_number;
    input [31:0]mfc0_number;
    input hardware_interrupt;
    input [31:0]sepc_address;
    input request;
    input [31:0]ins,current_PC;
    output reg Flush_Pipeline=1'b0;
    output reg [31:0]result, next_PC;
    output reg  Zero;
    output reg [4:0]exceptioncode;
    output reg [31:0]HI,LO;
    
    
    reg [5:0]op,func=6'b0;
    reg [4:0]shamt=5'b0;
    reg [63:0]temp=64'b0;//for instruction mul
    
    
    always @(*) begin
        exceptioncode=0;
        op=ins[31:26];
        func=ins[5:0];
        Flush_Pipeline=1'b0;
        next_PC=current_PC+4;
        if(hardware_interrupt == 1)begin
        //this is the part of interruption
        //this place is used for deciding the position of interruption
            next_PC = 32'b00000+32'b101000;
            result = current_PC + 4;
            Flush_Pipeline = 1'b1;
        end
        else
        case(op)
            6'b000000: begin
                    case(func)
                            //syscall
                            6'b001100:
                            begin
                                next_PC        = 32'b00000+32'b101010;//offset =30
                                result         = current_PC + 4 ;
                                Flush_Pipeline = 1'b1;
                            end
                            //sll(nop when shamt=5'b0)
                            6'b000000:begin
                                result=A << shamt;
                            end
                            //sllv
                            6'b000100:begin
                                result=A << B;
                            end
                            //srl(logical)
                            6'b000010:begin
                                result={1'b0,A} >> {{28{1'b0}},shamt};
                            end
                            //srlv
                            6'b000110:begin
                                result={1'b0,A} >> {1'b0,B};
                            end
                            //sra(arithmetic)
                            6'b000011:begin
                                result=A >> {{27{shamt[4]}},shamt};
                            end
                            //srav
                            6'b000111:begin
                                result=A >> B;
                            end
                            //and
                            6'b100100:begin
                                result=A&B;
                            end
                            //or
                            6'b100101:begin
                                result=A|B;
                            end
                            //xor
                            6'b100101:begin
                                result=A^B;
                            end
                            //nor
                            6'b100111:begin
                                result=~(A|B);
                            end
                            //add
                            6'b100000:begin
                                result=A+B;
                                if(A[31]^B[31]==0)
                                begin
                                    if(result[31]!=A[31])
                                    begin
                                    //ts exceptioncode is wrong but you can change it freely
                                        exceptioncode = 5'b01110;
                                    end
                                end
                            end
                            //addu
                            6'b100001:begin
                                result={1'b0,A}+{1'b0,B};
                            end
                            //sub
                            6'b100010:begin
                                result=A-B;
                            end
                            
                            //subu
                            6'b100011:begin
                                result={1'b0,A}-{1'b0,B};
                            end
                            
                            //mul
                            6'b000010:begin
                                temp=A*B;
                                result=temp[31:0];
                                HI=temp[63:32];
                                LO=temp[31:0];
                            end
                            
                            //slt
                            6'b101010:begin
                                result=A<B ? 1:0;
                                //$display("slt got");
                            end
                            
                            //sltu
                            6'b101011:begin
                                result={1'b0,A}<{1'b0,B} ? 1:0;
                            end
                            
                            //jr
                            6'b001000:begin
                                next_PC=A;
                                 Flush_Pipeline=1'b1;
                            end
                            default: begin
                                $display("alu.v line77: %d op=%x ,func=%x unknown instruction" , $time , op, func ) ;
                            end   
                            
                       endcase
                   
                
                
                
                

                    
                end
                
                //eret
            6'b010000:begin
                if(ins[5:0]==6'b011000 && ins[25]==1)
                    begin
                        next_PC        = sepc_address;
                        Flush_Pipeline = 1'b1;
                    end
                else if(ins[25:21]==6'b00100 )//mtc0 //mtc0 mtc0 rd, rt : CP0[rd] <= GPR[rt]
                begin
                    result=B;
                end
                else if(ins[25:21]==6'b00000 )//mfc0  //mfc0 mfc0 rt, rd : GPR[rt] <= CP0[rd]
                begin
                    result=mfc0_number;
                end
                else if(ins[25:21]==6'b01011 )//di di rt
                begin
                    result=status_number;
                end
                else
                    begin
                        $display("alu.v line138: %d op= %x unknown instruction" , $time , op ) ;
                    end
                if(ins[5:0]==0)
                begin
                        
                end

            end
            6'b001101:begin
                result=A|{{16{1'b0}},ins[15:0]};
            end
            
            //ori
            6'b001101:begin
                result = A | {16'b0,ins[15:0]};
            end
            
            //addiu
            6'b001001:begin
                result={1'b0,A}+{1'b0,{16'b0,ins[15:0]}};
            end
            
            //addi
            6'b001000:begin
                result=A+{{16{ins[15]}},ins[15:0]};
            end
            
            //slti
            6'b001010:begin
                result=A<{{16{ins[15]}},ins[15:0]} ? 1:0;
            end
            
            //lw
            6'b100011:begin
                result={1'b0,A}+{{16{ins[15]}},ins[15:0]};
            end
            
            //sw
            6'b101011:begin
                result={1'b0,A}+{{16{ins[15]}},ins[15:0]};
            end
            
            
            //beq, b(Unconditional Branch when [0,0,addr])
            6'b000100:begin
                //result= A<B
                if(A==B)
                begin
                    next_PC=current_PC+{{14{ins[15]}},ins[15:0],2'b0};
                    Flush_Pipeline=1'b1;
                end
            end
            
            //bal(branch and link)
            6'b000001:begin
                next_PC={next_PC[31:28],ins[25:0],2'b0};
                result=current_PC+8;//������+4����ˮ��+8�Ȳ�ִ�У��ӳ��򷵻غ�ִ��
                Flush_Pipeline=1'b1;
            end
            
            //bgtz(Branch Greater Than Zero)
            6'b000111:begin
                //result= A<B
                if(A > 32'b0)
                begin
                    next_PC=current_PC+{{14{ins[15]}},ins[15:0],2'b0};
                    Flush_Pipeline=1'b1;
                end
            end
            
            //blez(Branch on Less Than or Equal to Zero)
            6'b000110:begin
                //result= A<B
                if((A < 32'b0)||(A == 32'b0))
                begin
                    next_PC=current_PC+{{14{ins[15]}},ins[15:0],2'b0};
                    Flush_Pipeline=1'b1;
                end
            end 
            
            //bltz(Branch on Less Than Zero)
            6'b000001:begin
                //result= A<B
                if(A < 32'b0)
                begin
                    next_PC=current_PC+{{14{ins[15]}},ins[15:0],2'b0};
                    Flush_Pipeline=1'b1;
                end
            end
            
            //bne
            6'b000101:begin
                    //result= A<B
                    if(A != B)
                    begin
                        next_PC=current_PC+{{14{ins[15]}},ins[15:0],2'b0};
                        Flush_Pipeline=1'b1;
                    end
                end
            //lui
            6'b001111:begin
                result= {ins[15:0],16'b0};
            end
            
            //j
            6'b000010:begin
                next_PC={next_PC[31:28],ins[25:0],2'b0};
                Flush_Pipeline=1'b1;
            end
            
            //jal
            6'b000011:begin
                next_PC={next_PC[31:28],ins[25:0],2'b0};
                result=current_PC+8;//������+4����ˮ��+8�Ȳ�ִ�У��ӳ��򷵻غ�ִ��
                Flush_Pipeline=1'b1;
            end
            
            default: begin
                        $display("alu.v line138: %d op= %x unknown instruction" , $time , op ) ;
                    end   
        endcase
        Zero=(result==0);
    end

endmodule
