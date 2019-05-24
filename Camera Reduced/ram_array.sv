
module ram_array(clk, x_addr, y_addr, din, write, dout);
	input logic clk, write;
	input  logic [639:0] x_addr; 
	input  logic [479:0] y_addr;
	input  logic din;
	output logic dout;
	
	//black and white memory module for 640x480
	reg frame [100][100];
	
	//write operation
	always_ff @(posedge clk) begin
		if (write) 
			frame[x_addr][y_addr] <= din;
	end
	
	assign dout = frame[x_addr][y_addr];
	
endmodule

