`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/14 00:37:50
// Design Name: 
// Module Name: CP0
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


module CP0(clk,mfc0,mtc0,eret,syscall,request,pc_address,exceptioncode,hardware_interrupt,sepc_address,
    rd_ID,rd_EXE,mfc0_number,di,ei,status_number);
    input clk,eret,syscall,request;
    input mfc0,mtc0;
    input [4:0]rd_ID;
    input [4:0]rd_EXE;
    input [31:0]pc_address;
    input [4:0]exceptioncode;
    input di,ei;
    output reg hardware_interrupt;
    output reg [31:0]sepc_address;
    output reg [31:0]mfc0_number;
    output reg [31:0]status_number;
    integer i;
    reg [31:0]register[31:0];
    
    
    initial begin
        for(i = 0;i<=31;i = i + 1)
        begin
            register[i] = 0;
        end
        register[12]=32'd0;
        hardware_interrupt = 0;
        sepc_address = 0;
    end
    wire [31:0]cause;// regster[13]
    wire [31:0]status;//  regster[12] assume that status[0] is IE
    reg f_1;
    reg num = 0;
    always @(*) begin
        register[13][31]=0;
        register[13][6:2] = exceptioncode;
        register[13][17:8] = request;
        
    end
    always @(posedge clk)
    begin
        f_1 = request;
        // do interrupt
        if(f_1 == 1'b1 && num < 1)
        begin
            hardware_interrupt <= 1 ;
            num <= 1;
        end
        // do not interrupt
        else if(f_1 == 1'b1 && num==1) 
        begin
            hardware_interrupt <= 0;
        end
        // no interrupt
        else begin
            num <= 0;
            hardware_interrupt <= 0;
        end
    end
    always @(negedge clk) begin
            if(hardware_interrupt == 1)begin
                register[14] <= pc_address + 4 ;
                sepc_address <= pc_address + 4 ;
            end
            else if(syscall == 1)begin
                register[14] <= pc_address;
                sepc_address <= pc_address;
            end
            else if(mtc0 == 1)begin
                register[rd_EXE] <= pc_address;
            end
            else if(mfc0 == 1)begin
                mfc0_number <= register[rd_EXE];
            end
            else if(di == 1)begin
                status_number <= register[12];
                register[12][0] <=1;

            end
            else if(ei== 1)begin
                status_number <= register[12];
                register[12][0] <=0;
            end
    end

    
    always@(*)
    begin
        case (register[13][6:2])
            5'b01110: $display("CPO.v 97 suan shu yi chu ");
            default: $display(" CPO.v 98 wei ding yi de yi chang");
        endcase
    end
endmodule
