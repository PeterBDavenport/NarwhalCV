/* This module takes in a 5 bit number that represents the total
	number of cars in the parking garage. It will display Clear
	when the garage is empty and full when it reaches 25 on the
	hex displays. Other wise, it displays the number on two hex 
	displays. 

*/
module display(circle, square, triangle, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  logic  circle, square, triangle;
	output logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	
	logic [4:0] num5, num4, num3, num2, num1, num0;
	
	//Six seg7's called to control each seg7 display
	seg7 dis5(.bcd(num5), .out(HEX5));
	seg7 dis4(.bcd(num4), .out(HEX4));
	seg7 dis3(.bcd(num3), .out(HEX3));
	seg7 dis2(.bcd(num2), .out(HEX2));
	seg7 dis1(.bcd(num1), .out(HEX1));
	seg7 dis0(.bcd(num0), .out(HEX0));
	
	always_comb begin
		if(circle) begin
			//C			I			r	   	  c          L          E
			num5 = 12; num4 = 1; num3 = 16; num2 = 12; num1 = 17; num0 = 14;
		end
		else if(square) begin
			//s	     q	       u	         A	        r          E
			num5 = 20; num4 = 19; num3 = 24; num2 = 10; num1 = 16; num0 = 14;
		end
		else if(triangle) begin 
			//t		  r          i         A          n          g            
			num5 = 22; num4 = 16; num3 = 1; num2 = 10; num1 = 23; num0 = 25; 		
		end
		else begin
			num5 = '1; 	  num4 = '1;    num3 = '1; 	num2 = '1;    num1 = '1;    num0 = '1; 	
		end
			
	end
	
endmodule


module display_testbench();
	logic  circle, square, triangle;
	logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	display dut (.*); // ".*" Implicitly connects all ports to variables with matching names
	integer i;
	initial begin
		for(i = 0; i < 25; i++) begin     
			circle<=1; square<=1; triangle<=1; 
		end  
	end
endmodule
