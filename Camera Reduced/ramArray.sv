/*	This memory module uses an array to store data.
 * The data size is 32x4.
 */

module ram_array(addr, clk, din, wr, dout);
	input logic clk, wr;
	input  logic [4:0] addr; //5 bit addres for 32 slots
	input  logic [3:0] din;
	output logic [3:0] dout;
	
	//memory with array
	logic [3:0] array_reg [31:0];
	
	//write operation
	always_ff @(posedge clk) begin
		if (wr) 
			array_reg[addr] <= din;
	end
	
	//read operation is registered to be synchronous with clock
	assign dout = array_reg[addr];
	
endmodule

