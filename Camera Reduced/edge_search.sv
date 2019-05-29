module edge_search(input logic [9:0] search_x0, search_y0, search_x1, search_y1,
                   input logic start, clk, reset,
                   input logic [1:0] search_direction, 
						 output logic [9:0] found_x, found_y,
						 output logic done, 
						 output logic found,
						 //connections to pixel cache
						 output logic [9:0] x, y,  //location of pixel to read.
						 output logic request,     //request a new pixel
						 input logic pixel, 			// pixel (true or false), only valid when ready is asserted
						 input logic ready);   		// true when pixel cache found pixel and outputs value
						 
		enum {IDLE, LOAD, REQ_PIXEL, EVAL_PIXEL, FINISHED} ps, ns;
		enum {UP, DOWN, LEFT, RIGHT} direction;
		
		//location of current pixel begin evaluated
		logic [9:0] x_count, y_count;
		
		//define derection from input, this is fixed 
		//for the module and should not change
		always_comb begin
			case(search_direction)
			2'b00 : direction = UP;
			2'b01 : direction = DOWN;
			2'b10 : direction = LEFT;
			2'b11 : direction = RIGHT;
			endcase
		end
		
		//drives the state machine
		always_comb begin
			case(ps) 
			IDLE      : begin
								if(start)  ns = LOAD;
								else 		  ns = IDLE;
							end
			LOAD      :  			     ns = REQ_PIXEL;
			REQ_PIXEL : begin
								if(ready)  ns = EVAL_PIXEL;
								else		  ns = REQ_PIXEL;
							end
			EVAL_PIXEL: begin
								if(pixel || (x_count==search_x1 && y_count==search_y1)  )
											  ns = FINISHED; // pixel is 1, than found and finished or 
																  // x,y reach end, finished and not found
								else 		  ns = REQ_PIXEL;
							end
			FINISHED  : begin
								if (start) ns = LOAD;
								else 		  ns = FINISHED;
							end
			endcase			
		end
		
		always_ff @(posedge clk) begin
			if(reset) 
				ps <= IDLE;
			else begin
				ps <= ns;
					if (ps==LOAD) begin
						x_count <= search_x0;
						y_count <= search_y0;
					end
					else if(REQ_PIXEL) begin 
						request <= 1;
						x <= x_count;
						y <= y_count;
					end
					else if (EVAL_PIXEL) begin
						case (direction) 
							//starting in bottom right and moving up than left on return
							UP    :  if(y_count==search_y1) begin y_count <= search_y0;
																			  x_count <= x_count - 1; end
										else						  begin y_count <= y_count - 1; end
							//starting in top left and moving down than right on return
							DOWN  :  if(y_count==search_y1) begin y_count <= search_y0;
																			  x_count <= x_count + 1; end
										else						  begin y_count <= y_count + 1; end
							//starting in bottom right and moving left than up on return
							LEFT  :  if(x_count==search_x1) begin x_count <= search_x0;
																			  y_count <= y_count - 1; end
										else						  begin y_count <= y_count - 1; end
							//starting in top left and moving right than down on return
							RIGHT :  if(x_count==search_x1) begin x_count <= search_x0;
																			  y_count <= y_count + 1; end
										else						  begin x_count <= x_count + 1; end
						endcase
					end
			end
		end

endmodule

module edge_search_testbench();

		  logic [9:0] search_x0, search_y0, search_x1, search_y1;
		  logic start, clk, reset;
		  logic [1:0] search_direction; 
		  logic [9:0] found_x, found_y;
		  logic done; 
		  logic found;
		  //connections to pixel cache
		  logic [9:0] x, y;  //location of pixel to read.
		  logic request;     //request a new pixel
		  logic pixel; 		// pixel (true or false), only valid when ready is asserted
		  logic ready;

edge_search dut(.search_x0, .search_y0, .search_x1, .search_y1, .start, .clk, .reset, 
					 .search_direction, .found_x, .found_y, .done, .found, .x, .y, .request, 
					 .pixel,  .ready); 
			
			// Set up the clock.
			parameter CLOCK_PERIOD=100;
			initial begin
				clk <= 0;
				forever #(CLOCK_PERIOD/2) clk <= ~clk;
			end	
			integer i, j;
			initial begin
				reset<=1; @(posedge clk);
				reset<=0; @(posedge clk);
				search_x0 <= '0; @(posedge clk);
				search_y0 <= '0; @(posedge clk);
				search_x1 <= '1; @(posedge clk);
			   search_y1 <= '1; @(posedge clk);
				search_direction <= 2'b11; @(posedge clk);
				start<=1; @(posedge clk);
				start<=0; @(posedge clk);
				ready<=1; @(posedge clk);
				
				for(i=0;i<640;i++) begin
					for(j=0;j<480;j++) begin
						ready<=1; @(posedge clk);
						ready<=0; @(posedge clk);
						pixel<=0;  @(posedge clk);
						if(i==100 && j==100)
							pixel <= 1; @(posedge clk);
							
					end
				end
				

				repeat(500) @(posedge clk);
				
				$stop;
			end
endmodule 