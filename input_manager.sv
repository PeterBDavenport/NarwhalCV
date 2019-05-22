module inputManager(clk, reset, key, out);   
	input  logic 	   clk, key, reset;
	output logic out;  
	enum {WAIT, PRESSED} ns, ps;
	
	always_comb begin
	
	//key is normally high, press is one, invert key first

	
	case (ps)
		WAIT: 	 if(key)begin out=1; ns = PRESSED; end
		          else   begin out=0; ns = WAIT;    end
		PRESSED:  if(key)begin out=0; ns = PRESSED; end
		          else   begin out=0; ns = WAIT;    end
	endcase

	end
	// DFFs   
	always_ff @(posedge clk) begin     
			if(reset)begin
				  ps <= WAIT;
			end
			else begin 
				  ps <= ns;
			end
	end     
	
endmodule  

module inputManager_testbench();   
	logic clk, key, reset;
	logic out;  
	logic ns, ps;     
	
	inputManager dut (.clk, .reset, .key, .out);      
	// Set up the clock.   
	parameter CLOCK_PERIOD=100;   
	initial begin    
		clk <= 0;    
		forever #(CLOCK_PERIOD/2) clk <= ~clk;   
	end      
	// Set up the inputs to the design.  Each line is a clock cycle.   
	initial begin                        
										 @(posedge clk);    
		reset <= 1;         		 @(posedge clk);    
		reset <= 0;              @(posedge clk);                        
						key <= 1;    @(posedge clk);                        
						key <= 1;	 @(posedge clk);                        
						key <= 1;    @(posedge clk);                
					   key <= 1;    @(posedge clk);                
						key <= 0;    @(posedge clk);                
						             @(posedge clk);                        
										 @(posedge clk);                        
			                      @(posedge clk);                        
										 @(posedge clk);                
					                @(posedge clk);                        
										 @(posedge clk); 
								       @(posedge clk);		 
		$stop; // End the simulation.   
	end  
endmodule
