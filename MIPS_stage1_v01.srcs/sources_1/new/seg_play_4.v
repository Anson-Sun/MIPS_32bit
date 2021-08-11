`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/07 15:57:56
// Design Name: 
// Module Name: seg_play2
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


module seg_play_4(
   input clk,
    input [31:0]sw,
    output reg[7:0]seg=8'b00000000,
    output reg[7:0]an=8'b11111110
    );
    reg [31:0]divclk_cnt=32'b0;
    reg divclk=1'b0;
    //reg [7:0]seg=8'b0;
    //reg [7:0]an=8'b11111110;
    reg [31:0]disp_dat=4'b0;//目前刷新到要该位要表示显示的数字
    reg [3:0]disp_bit=3'b0;//目前刷新到显示的位
    parameter maxcnt=250;
    
    
    always@(posedge clk)begin
        if(divclk_cnt == maxcnt - 1)
        begin
            divclk     <=~divclk;
            divclk_cnt <=32'b0;
        end
        else
        begin
            divclk_cnt <= divclk_cnt+1'b1;
        end
    end
    
    always@(posedge divclk)begin
    //always@(posedge clk)begin
        if(disp_bit>=7)
           disp_bit <= 0;//8位都刷新过了就回到第一位，循环刷新
         else
            disp_bit <= disp_bit+1;//一到下一位去刷新
            
         case(disp_bit)
            3'd0:
            begin
                disp_dat <=sw[3:0];
                an       <=8'b11111110;
            end
            3'd1:
            begin
                disp_dat <=sw[7:4];
                an       <=8'b11111101;
            end
            3'd2:
            begin
                disp_dat <=sw[11:8];
                an       <=8'b11111011;
            end
            3'd3:
            begin
                disp_dat <=sw[15:12];
                an       <=8'b11110111;
            end
            3'd4:
            begin
                disp_dat <=sw[19:16];
                an       <=8'b11101111;
            end
            3'd5:
            begin
                disp_dat <=sw[23:20];
                an       <=8'b11011111;
            end
            3'd6:
            begin
                disp_dat <=sw[27:24];
                an       <=8'b10111111;
            end
            3'd7:
            begin
                disp_dat <=sw[31:28];
                an       <=8'b01111111;
            end
            default:
            begin
                disp_dat <=2'b0;
                an       <=8'b11111111;
            end
         endcase
    end
    
    always@(disp_dat)begin
        case(disp_dat)
            4'h0:seg=8'b00000011;
            4'h1:seg=8'b10011111;
            4'h2:seg=8'b00100101;
            4'h3:seg=8'b00001101;
            4'h4:seg=8'b10011001;
            4'h5:seg=8'b01001001;
            4'h6:seg=8'b01000001;
            4'h7:seg=8'b00011111;
            4'h8:seg=8'b00000001;
            4'h9:seg=8'b00001001;
            4'ha:seg=8'b00010001;
            4'hb:seg=8'b11000001;
            4'hc:seg=8'b11100101;
            4'hd:seg=8'b10000101;
            4'he:seg=8'b01100001;
            4'hf:seg=8'b01110001;
            default:seg=8'b11111111;
        endcase
    end
endmodule
