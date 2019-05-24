module pixel_counter(
	input logic clk, reset, 
	input logic iVGA_HS, iVGA_VS,
   output logic		[12:0] x_count, // Position horizontally
   output logic		[12:0] y_count // Position vertically
	);
	
	always_ff @(posedge clk) begin
		if(!iVGA_VS) begin
			x_count <= '0;
			y_count <= '0;
		end
		else begin
			if(iVGA_HS) x_count <= x_count + 1;
			else begin
				x_count <= '0;
				y_count <= y_count + 1;
			end
		end
	end
	
endmodule