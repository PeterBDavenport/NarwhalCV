module input_manager(clk, reset, key, out);   
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
