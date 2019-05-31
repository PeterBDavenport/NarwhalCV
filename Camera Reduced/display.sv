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
			//C				I				  r				 c					L				  E
			dis5 = 5'h0C; dis4 = 5'h01; dis4 = 5'h10; dis3 = 5'h0C; dis2 = 5'h11; dis1 = 5'h0E; dis0 = '1;
		end
		else if(square) begin
			//s				q			     u				 A					r				  E
			dis5 = 5'h13; dis4 = 5'h12; dis4 = 5'h17; dis3 = 5'h0A; dis2 = 5'h11; dis1 = 5'h0E; dis0 = '1;
		end
		else if(triangle) begin 
			//t				r			     i				 A					n				  g            l
			dis5 = 5'h15; dis4 = 5'h10; dis4 = 5'h01; dis3 = 5'h0A; dis2 = 5'h16; dis1 = 5'h18; dis0 = 5'h11;		
		end
		else begin
			dis5 = '1; dis4 = '1; dis4 = '1; dis3 = '1; dis2 = '1; dis1 = '1; dis0 = '1;
		end
			
	end
	
endmodule


module display_testbench();
	logic  [4:0] num;
	logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
	display dut (.*); // ".*" Implicitly connects all ports to variables with matching names
	integer i;
	initial begin
		for(i = 0; i < 25; i++) begin     
			num = i; #10;  
		end  
	end
endmodule
