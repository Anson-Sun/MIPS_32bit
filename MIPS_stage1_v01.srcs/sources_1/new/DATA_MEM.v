`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/25 10:38:56
// Design Name: 
// Module Name: DATA_MEM
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


module DATA_MEM(
    input        Clock,
        input       memRead,
		input        we,
		input [31:0] addr,
		input [31:0] datain,
		input [15:0] sw,
		output reg[31:0] dataout
    );
    
    wire [17:0] addr_d_mem;
    reg [31:0] BaseRAM [0:1023];
	reg [31:0] data_b,data_w,data_h,
	           data_LittleEndian_in,data_LittleEndian_out;
	
	always@(*) begin
        data_LittleEndian_in <= {datain[7-:8], datain[15-:8], datain[23-:8], datain[31-:8]};
        dataout              <= {data_LittleEndian_out[7-:8], data_LittleEndian_out[15-:8], data_LittleEndian_out[23-:8], data_LittleEndian_out[31-:8]};
	end
	
	assign addr_d_mem = addr[19:2];
	
	always @ (posedge Clock) begin
		if (we) 
		  BaseRAM[addr_d_mem] <= datain;
		  //ram[addr_d_mem] <= data_LittleEndian_in;
	end
    always @(negedge Clock)begin
        if(memRead==1'b1)begin
                dataout <= BaseRAM[addr_d_mem];
                //data_LittleEndian_out <= ram[addr_d_mem];
                //dataout           <= {data_LittleEndian[7-:8], data_LittleEndian[15-:8], data_LittleEndian[23-:8], data_LittleEndian[31-:8]};
        end
    end
	integer i;
    
endmodule
