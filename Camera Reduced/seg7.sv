/*
	This module converts a number to a corresoponding 
	hex display value. It can display 0-9 and several 
	letters.
*/
module seg7(bcd, out);
	input  logic [5:0] bcd;
	output logic [6:0] out;
	
	always_comb begin
		case (bcd)      // gfedcba
			0 : out = 7'b1000000; //0
			1 : out = 7'b1111001; //1
			2 : out = 7'b0100100; //2
			3 : out = 7'b0110000; //3
			4 : out = 7'b0011001; //4
			5 : out = 7'b0010010; //5
			6 : out = 7'b0000010; //6
			7 : out = 7'b1111000; //7
			8 : out = 7'b0000000; //8
			9 : out = 7'b0011000; //9
			10 : out = 7'b0001000; //A
			11 : out = 7'b0000011; //b
			12 : out = 7'b1000110; //C
			13 : out = 7'b0100001; //d
			14 : out = 7'b0000110; //E
			15 : out = 7'b0001110; //F
			16 : out = 7'b0101111; //r
			17 : out = 7'b1000111; //L
			19 : out = 7'b0011000; //q
			20 : out = 7'b0010010; //S
			21 : out = 7'b0001001; //F
			22 : out = 7'b0000111; //t
			23 : out = 7'b0101011; //n 
			24 : out = 7'b1000001; //u
			25 : out = 7'b0010000; //g
			
			default : out = 7'b0000000; //off
		endcase
	end
endmodule

module seg7_testbench();

	logic [5:0] bcd;
	logic [6:0] out;
	
	seg7 dut (bcd, out);
	
	integer i;			  
	initial begin 
		for(i=0; i<10; i++) begin
			{bcd} = i; #10;
		end
	end  
endmodule