module ram(addr, clk, din, wr, dout);

	input logic clk, wr;
	input  logic [4:0] addr; //5 bit addres for 32 slots
	input  logic [3:0] din;
	output logic [3:0] dout;
	
	ram32x4 r1(.address(addr), .clock(clk),	.data(din),	 .wren(wr),	.q(dout));

	
	
endmodule
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module ram_testbench();

	logic clk, wr;
	logic [4:0] addr; //5 bit addres for 32 slots;
	logic [3:0] din, dout;

	// Clock generation
	parameter PERIOD = 100; // period = length of clock
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end

	ram dut (addr, clk, din, wr, dout); // ".*" Implicitly connects all ports to variables with matching names
	
	initial begin
		
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00000;  din<=4'b0101; @(posedge clk);
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00001;  din<=4'b0100; @(posedge clk);
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00010;  din<=4'b0111; @(posedge clk);
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00011;  din<=4'b1101; @(posedge clk);
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00100;  din<=4'b1111; @(posedge clk);
		wr<=0; 	addr<=5'b00000;  					 @(posedge clk);
		wr<=1; 	addr<=5'b00101;  din<=4'b0000; @(posedge clk);
		
		
		$stop; // End simulation
	end
endmodule
