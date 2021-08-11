`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/31 15:18:47
// Design Name: 
// Module Name: MIPS_SZJ_TOP
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


module MIPS_SZJ_TOP(
        input             CPU_RESET_N,
		input             CLK100MHZ  ,
		output  [15:0]    led
    );
    
    wire [7:0]seg;
    wire [7:0]AN;
    
    wire clock_100M, clock_5M, clock_10M, clock_20M, clock_50M, clock_75M,clock_1HZ ;
	 
     slow_clock_1HZ u_1HZ( CLK100MHZ,clock_1HZ,1'b0);
	 clk_wiz_0 clk_wiz( .clk_in1 ( CLK100MHZ  ) ,  
                   .clk_out1( clock_5M ) , 
                         .clk_out2( clock_10M   ) ,
                         .clk_out3( clock_20M  ) ,
                         .clk_out4( clock_50M  ) ,
                         .clk_out5( clock_75M  ) , 
                         .clk_out6( clock_100M ) 
                         ) ;
  
    wire [15:0] led_data ;
    wire [31:0] display_data;
    wire [31:0] seg_displaydata;
    MIPS_CPU_datapath m_cpu_mips32(
         .request (1'b0),
         .reset      (CPU_RESET_N),
         //.clk        (  clock_5M    ),
		     .clk        ( CLK100MHZ     ) ,
         //.clk        ( clock_1HZ     ) ,
         //.clk        ( clock_20M     ) ,
         //.clk        ( clock_50M     ) ,
         //.clk        ( clock_75M     ) ,
         //.clk        ( clock_100M    ) ,
         //.clk        ( clock_1HZ     ) ,
		 .sw         (16'b0),
		 .display_data        ( display_data          ),
		 .seg_displaydata     ( seg_displaydata       )
    );
    assign led = display_data[15:0] ;
    seg_play_4 u_seg(clock_5M,seg_displaydata,seg,AN);
endmodule


