/*	This memory module uses an array to store data.
 * The data size is 32x4.
 */

module ram_array(clk, x_addr, y_addr, din, write, dout);
	input logic clk, write;
	input  logic [100:0] x_addr, y_addr; //5 bit addres for 32 slots
	input  logic [23:0] din;
	output logic [23:0] dout;
	
	//   color           x           y
	//reg [23:0] frame [WIDTH-1:0][HEIGHT-1:0];
	reg [23:0] frame [100:0][100:0];
	
	//write operation
	always_ff @(posedge clk) begin
		if (wr) 
			frame[x_addr][y_addr] <= din;
		else
			dout = frame[x_addr][y_addr];
	end
	
	//read operation is registered to be synchronous with clock
	assign 
	
endmodule

