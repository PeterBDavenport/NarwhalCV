module video_still(
	input logic clk, reset, start,
	input logic iVGA_VS, iVGA_HS,
	output logic write,
	output logic [7:0]x, y
	);

//	logic [9:0] x_count, y_count;
//	
//	
//	enum {S_IDLE, S_FRONT_PORCH, S_SYNC, S_LOAD} ps, ns;
//	
//	always_comb begin
//		case(ps)
//			S_IDLE: begin
//				if(start) ns = S_FRONT_PORCH;
//				else ns = S_IDLE;
//			end			
//			S_FRONT_PORCH: begin
//				if(iVGA_VS) ns = S_FRONT_PORCH;
//				else ns = S_LOAD;
//			end
//			S_SYNC: begin
//				if (iVGA_VS) ns = S_LOAD;
//				else ns = S_SYNC;
//			end
//			S_LOAD: begin
//				if (iVGA_VS) ns = S_LOAD;
//				else ns = S_IDLE;
//			end
//		endcase
//	end
//	
//	always_ff @(posedge clk) begin
//		if(reset) begin
//			ps <= S_IDLE;
//			write<=0;
//		end else
//			ps <= ns;
//	
//		case(ps)
//			S_IDLE: begin
//				x_count <= '0;
//				y_count <= '0;
//			end
//			S_LOAD: begin
//				// Store the pixel.
//				x<=x_count;
//				y<=y_count;
//				write<=1;
//			end
//		endcase
//	end
	
endmodule

module video_still_testbench();

	logic clk, reset, start;
	logic iVGA_VS, iVGA_HS;
	logic write;
	logic [7:0]x, y;
	
	video_still dut(clk, reset, start, iVGA_VS, iVGA_HS, write, x, y);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end	
	parameter WIDTH  = 100;
	parameter HEIGHT = 100;
	integer i, j;
	initial begin
	reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);
	start <= 1; iVGA_VS <=1; iVGA_HS <= 0;  @(posedge clk);
	iVGA_HS <= 1;  @(posedge clk);
	iVGA_VS <= 0;  @(posedge clk);
	iVGA_VS <= 1;  @(posedge clk);
		for(i=0;i<WIDTH;i++) begin
			iVGA_HS <= 0; @(posedge clk);
			iVGA_HS <= 1; @(posedge clk);
			for(j=0;j<HEIGHT;j++) begin
				@(posedge clk);
			end
		end
		iVGA_VS <= 0; @(posedge clk);
		iVGA_VS <= 1; @(posedge clk);
	$stop;
	end
	
endmodule