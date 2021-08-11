`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/24 08:44:41
// Design Name: 
// Module Name: INS_MEM
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


module INS_MEM(addr,ins);

    input [31:0]addr;
    output reg [31:0]ins;
    //reg  [31:0] rom [2147483648:2147484671];
    reg [31:0] ExtRAM [0:1023];
    reg [31:0]addr_temp;
    reg [31:0]ins_LittleEndian;
    initial begin
	     
	     //$readmemh("D:\\Program_Files\\MIPS CPU\\race\\Machine_code\\Fib2.txt",rom);
	     //$readmemh("D:\\Program_Files\\MIPS CPU\\race\\Machine_code\\fib_LittleEndian1.txt",rom);
        ExtRAM[0]=32'h34080001;
        ExtRAM[1]=32'h34090001;
        ExtRAM[2]=32'h34110004;
        ExtRAM[3]=32'h340c0100;
        ExtRAM[4]=32'h3c048040;
        ExtRAM[5]=32'h008c6821;
        ExtRAM[6]=32'h01095021;
        ExtRAM[7]=32'h35280000;
        ExtRAM[8]=32'h35490000;
        ExtRAM[9]=32'hac890000;
        ExtRAM[10]=32'h8c8b0000;
        ExtRAM[11]=32'h152b0004;
        ExtRAM[12]=32'h34000000;
        ExtRAM[13]=32'h00912021;
        ExtRAM[14]=32'h148dfff7;
        ExtRAM[15]=32'h34000000;
        ExtRAM[16]=32'h1620ffff;
        ExtRAM[17]=32'h34000000;
	     
    end	 
   
     always@(*)
     begin
        addr_temp=addr-32'h00000000;//for loogson race
        /*if( addr != 0 )
            ins = rom[addr_temp[9:2]];
        else
            ins = 0 ;*/
            //ins = rom[addr_temp[9:2]];
            //ins_LittleEndian = ExtRAM[addr_temp[9:2]];
            //ins = {ins_LittleEndian[7-:8], ins_LittleEndian[15-:8], ins_LittleEndian[23-:8], ins_LittleEndian[31-:8]};
            ins = ExtRAM[addr_temp[9:2]];
     end
     

endmodule
