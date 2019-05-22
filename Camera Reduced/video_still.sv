module video_still(
	input logic clk, reset, start,
	input logic iVGA_VS, iVGA_HS,
	output logic write,
	output logic [7:0]x, y,
	);

	logic [9:0] x_count, y_count;
	
	
	enum {S_IDLE, S_FRONT_PORCH, S_SYNC, S_LOAD} ps, ns;
	
	always_comb begin
		case(ps)
			S_IDLE: begin
				if(start) ns = S_FRONT_PORCH;
				else ns = S_IDLE;
			end			
			S_FRONT_PORCH: begin
				if(iVGA_VS) ns = S_FRONT_PORCH;
				else ns = S_SYNC;
			end
			S_SYNC: begin
				if (iVGA_VS) ns = S_LOAD;
				else ns = S_SYNC;
			end
			S_LOAD: begin
				if (iVGA_VS) ns = S_LOAD;
				else ns = S_IDLE;
			end
		endcase
	end
	
	always_ff @(posedge VGA_CLK) begin
		if(reset)
			ps <= S_IDLE;
		else
			ps <= ns;
	
		case(ps)
			S_IDLE: begin
				x_count <= '0;
				y_count <= '0;
			end
		
			S_LOAD: begin
				// Store the pixel.
				frame[x_count][y_count] <= {iVGA_R, iVGA_G, iVGA_B};
				
				// 
				if(iVGA_HS) x_count <= x_count + 1;
				else begin
					x_count <= '0;
					y_count <= y_count + 1;
				end
			end
		endcase
	end