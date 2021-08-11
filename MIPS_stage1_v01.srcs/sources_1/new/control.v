`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/26 10:46:49
// Design Name: 
// Module Name: control
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


module control(ins,op,func,Zero,RegDst,RegWr,memRead,memWr,memtoDst,syscall,eret,mfc0,mtc0,Break,di,ei);
    // 3 inputs about Zero and Instructions
    input[31:0]ins;
    input Zero;
    input [5:0]op,func;
    // 9 outputs 
    // 5 outputs are about basical database
    // 4 outputs are about interrupts
    output reg RegDst,RegWr,memRead,memWr,memtoDst;
    output reg syscall;
    output reg eret;
    output reg mfc0;
    output reg mtc0;
    output reg Break;
    output reg di,ei;
    //extOp and pcsource are not used
    //about extOp and pcsource is duringed in ALU modual
    //so extOp and pcsource is deleted by Hhc
    always @(*) begin
        case(op)
            6'b000000: begin
                     case(func)
                            //break
                            6'b001101:
                            begin
                                di=0;
                                ei=0;
                                Break=1;
                                // 4 outputs are about interrupts
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                // 5 outputs are about basical database
                                RegDst = 0;
                                memtoDst = 0;
                                memWr = 0;
                                memRead = 0;
                                RegWr = 0;
                            end
                            //syscall
                            6'b001100:
                            begin
                                di=0;
                                ei=0;
                            
                                // 4 outputs are about interrupts
                                syscall = 1;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                // 5 outputs are about basical database
                                RegDst = 0;
                                memtoDst = 0;
                                memWr = 0;
                                memRead = 0;
                                RegWr = 0;
                            end
                            //sll(nop when shamt=5'b0)
                            6'b000000:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //sllv
                            6'b000100:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //srl(logical)
                            6'b000010:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //srlv
                            6'b000110:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //sra(arithmetic)
                            6'b000011:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //srav
                            6'b000111:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //and
                            6'b100100:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //or
                            6'b100101:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //xor
                            6'b100101:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //nor
                            6'b100111:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=0;
                            end
                            
                            //add
                            6'b100000:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=1'b0;
                            end
                            
                            //addu
                            6'b100001:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=1'b0;
                            end
                            
                            //sub
                            6'b100010:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=1'b0;
                            end
                            
                            //subu
                            6'b100011:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=1'b0;
                            end
                            
                            //mul
                            6'b000010:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memWr=0;
                                memRead=1'b0;
                            end
                            
                            //slt
                            6'b101010:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memRead=1'b0;
                                memWr=0;
                            end
                            
                            //sltu
                            6'b101011:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memRead=1'b0;
                                memWr=0;
                            end
                            
                            //jr
                            6'b001000:begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1'b0;
                                memRead=1'b0;
                                memWr=0;
                            end
                            
                            default: begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=1'b0;
                                memtoDst=1'b0;
                                RegWr=1'b0;
                                memRead=1'b0;
                                memWr=0;
                                $display("control.v line99: %d op=%x ,func=%x unknown instruction" , $time , op, func ) ;
                                
                            end   
                       endcase
                   
                end
                // interrupt
                // problem1
                // eret
                6'b010000:
                    begin
                        if(ins[5:0] == 6'b011000 && ins[25]==1 )
                            begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 1;
                                mtc0 = 0;
                                mfc0 = 0;
                                RegDst=0;
                                memtoDst=0;
                                RegWr=0;
                                memRead=1'b0;
                                memWr=0;
                            end 
                        case(ins[25:21])
                            5'b00000: //mfc0 mfc0 rt, rd : GPR[rt] <= CP0[rd]
                            begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 0;
                                mfc0 = 1;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=1;
                                memRead=1'b0;
                                memWr=0;
                            end
                            //mtc0 mtc0 rd, rt : CP0[rd] <= GPR[rt]
                            5'b00100:
                            begin
                                di=0;
                                ei=0;
                                syscall = 0;
                                eret = 0;
                                mtc0 = 1;
                                mfc0 = 0;
                                RegDst=1;
                                memtoDst=0;
                                RegWr=0;
                                memRead=1'b0;
                                memWr=0;
                            end 
                            5'b01011:
                            begin
                                if(ins[5]==0)//di
                                begin
                                    di=1;
                                    ei=0;
                                    syscall = 0;
                                    eret = 0;
                                    mtc0 = 0;
                                    mfc0 = 0;
                                    RegDst=1;
                                    memtoDst=0;
                                    RegWr=1;
                                    memRead=1'b0;
                                    memWr=0;                                    
                                end
                                if(ins[5]==1)//ei
                                begin
                                    ei=1;
                                    di=0;
                                    syscall = 0;
                                    eret = 0;
                                    mtc0 = 0;
                                    mfc0 = 0;
                                    RegDst=1;
                                    memtoDst=0;
                                    RegWr=1;
                                    memRead=1'b0;
                                    memWr=0;                                    
                                end
                            end         
                        endcase
                    end
                //ori
                6'b001101:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //addiu
                6'b001001:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //addi
                6'b001000:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //slti
                6'b001010:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                   RegDst=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //lw
                6'b100011:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=1;
                    RegWr=1;
                    memRead=1'b1;
                    memWr=0;
                end
                
                //sw
                6'b101011:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=1;
                    memRead=1'b0;
                    RegWr=0;
                    memWr=1;
                end
                
                //beq
                6'b000100:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=0;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //bgtz
                6'b000111:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=0;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //blez
                6'b000110:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=0;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //bltz
                6'b000001:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=0;
                    memRead=1'b0;
                    memWr=0;
                end
                
                //bne
                6'b000101:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=0;
                    memRead=1'b0;
                    memWr=0;
                end
                                
               // lui
               6'b00_1111: begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;  
               end 
               
                
                //j
                6'b000010:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegWr=0;
                    memtoDst=0;
                    RegWr=1;
                    memRead=1'b0;
                    memWr=0;
                end
                
                 //jal
                6'b000011:begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    RegWr=1'b1;
                    memtoDst=0;
                    memRead=1'b0;
                    memWr=0;
                end
                
                default: begin
                    di=0;
                    ei=0;
                    syscall = 0;
                    eret = 0;
                    mtc0 = 0;
                    mfc0 = 0;
                    RegDst=0;
                    RegWr=1'b0;
                    memtoDst=0;
                    memRead=1'b0;
                    memWr=0;
                            $display("control.v line 197: %d op=%x unknown instruction" , $time , op ) ;
                end   
        endcase
        
    end

endmodule
