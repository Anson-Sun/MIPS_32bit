`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/31 15:24:53
// Design Name: 
// Module Name: tb_MIPS_CPU_ORI
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


module tb_MIPS_CPU_ORI;

    // Inputs
	reg CPU_RESET_N;
	reg CLK100MHZ;
	wire [15:0]led;
	// Outputs

	// Instantiate the Unit Under Test (UUT)
	MIPS_SZJ_TOP uut (
		.CPU_RESET_N(CPU_RESET_N), 
		.CLK100MHZ(CLK100MHZ),
		.led(led)
	);

	initial begin

		
		CLK100MHZ = 0;


		#100;
		CPU_RESET_N = 1 ;
		/*#400;
		request=1;*/
		
	end

		// #400;
		// request=0;
		// #1000;
		// request=1;
		// #400;
		// request=0;	
	always begin
	   #5 CLK100MHZ = ~CLK100MHZ ;
	end
      

endmodule

