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
			5'h00 : out = 7'b1000000; //0
			5'h01 : out = 7'b1111001; //1
			5'h02 : out = 7'b0100100; //2
			5'h03 : out = 7'b0110000; //3
			5'h04 : out = 7'b0011001; //4
			5'h05 : out = 7'b0010010; //5
			5'h06 : out = 7'b0000010; //6
			5'h07 : out = 7'b1111000; //7
			5'h08 : out = 7'b0000000; //8
			5'h09 : out = 7'b0011000; //9
			5'h0A : out = 7'b0001000; //A
			5'h0B : out = 7'b0000011; //b
			5'h0C : out = 7'b1000110; //C
			5'h0D : out = 7'b0100001; //d
			5'h0E : out = 7'b0000110; //E
			5'h0F : out = 7'b0001110; //F
			5'h10 : out = 7'b0101111; //r
			5'h11 : out = 7'b1000111; //L
			5'h12 : out = 7'b0011000; //q
			5'h13 : out = 7'b0010010; //S
			5'h14 : out = 7'b0001001; //F
			5'h15 : out = 7'b0000111; //t
			5'h16 : out = 7'b0101011; //n 
			5'h17 : out = 7'b1000001; //u
			5'h18 : out = 7'b0010000; //g
			
			default : out = 7'b1111111; //off
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