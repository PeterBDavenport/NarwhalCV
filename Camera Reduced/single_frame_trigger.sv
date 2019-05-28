/*
 * ################################################################################
 * ### single_frame_trigger #######################################################
 * ################################################################################
 *
 * ### MODULE OVERVIEW ###
 * This module will set the capture signal to high during the time when HS and VS
 * (the horizontal and vertical sync signals that indicate when a camera signal is
 * valid) are asserted for a single frame of pixels following a trigger signal.
 *
 *	### CONNECTIONS ###
 *  clk     - input  - Clock rate of the camera signal.
 *  reset   - input  - Reset the module into the waiting for trigger state.
 *  trigger - input  - Starts a single frame capture when asserted.
 *  VS      - input  - Vertical Sync signal from camera / input video stream.
 *  HS      - input  - Horizontal Sync singal from camera / input video stream.
 *  capture - output - Signal is true only when pixles are active (HS, VS both
 *                     asserted) and for one frame of pixels starting immediately
 *                     after the rizing edge of VS.
 */
 module single_frame_trigger(
    input logic clk,
    input logic reset,
    input logic trigger,
    input logic VS,
    input logic HS,
    output logic capture
    );
    
    // Tracking the VS value from last cycle.
    logic VS_old;
    
    // State machine:
    enum {S_waiting_for_trigger, S_waiting_for_frame_start, S_in_frame} ns, ps;
    always_comb begin
        case(ps)
        S_waiting_for_trigger: begin
            ns = trigger ? S_waiting_for_frame_start : S_waiting_for_trigger;
            capture = 1'b0;
        end
        S_waiting_for_frame_start: begin
            ns = (!VS_old && VS) ? S_in_frame : S_waiting_for_frame_start;
            capture = 1'b0;
        end
        S_in_frame: begin
            ns = VS ? S_in_frame : S_waiting_for_trigger;
            capture = HS && VS;
        end
        default: begin
            ns = S_waiting_for_trigger;
            capture = 1'b0;
        end
        endcase
    end
    	 
    always_ff @(posedge clk) begin
        // We need to know what VS was last cycle to detect the rizing
        // edge, to know when a frame starts.
        VS_old <= VS;

        // Each cycle we need to reset or go to the next state.
        if(reset)
            ps <= S_waiting_for_trigger;
        else
            ps <= ns;
    end
    
endmodule

/*
 * ################################################################################
 * ### single_frame_trigger_testbench #############################################
 * ################################################################################
 *
 * ### MODULE OVERVIEW ###
 * This module tests the single_frame_trigger module by simulating the expected VS,
 * HS signal and testing that the capture signal matches the expected single frame
 * capture behavior. The expected behavior is that the signal capture will be one
 * during only one frame of VS after the trigger command.
 */
module single_frame_trigger_testbench();
    logic clk, reset, trigger, VS, HS, capture;
    single_frame_trigger dut(clk, reset, trigger, VS, HS, capture);
    
    parameter PERIOD = 100;
	initial begin
        clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
    
    integer i;
	initial begin
        // Test a trigger that starts when VS is low.
		{reset, trigger, VS, HS} <= '0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        HS <= ~HS; trigger <= 1'b1; @(posedge clk);
        HS <= ~HS; trigger <= 1'b0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        VS <= 1'b1; HS <= ~HS; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        
        // Test a trigger that starts when VS is high.
        {reset, trigger, HS} <= '0; VS <= 1'b1; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        HS <= ~HS; trigger <= 1'b1; @(posedge clk);
        HS <= ~HS; trigger <= 1'b0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; VS <= 1'b0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        VS <= 1'b1; HS <= ~HS; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        
        // And continue to validate that this is only active for one frame.
        VS <= 1'b1; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        
        // Test a trigger that crosses the start.
		{reset, trigger, VS, HS} <= '0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        HS <= ~HS; trigger <= 1'b1; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        VS <= 1'b1; HS <= ~HS; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        HS <= ~HS; trigger <= 1'b0; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        
        // Test a trigger that crosses multiple frames
		{reset, trigger, VS, HS} <= '0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        HS <= ~HS; trigger <= 1'b1; @(posedge clk);
		HS <= ~HS; @(posedge clk);
		HS <= ~HS; @(posedge clk);
        VS <= 1'b1; HS <= ~HS; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end

 		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b1; HS <= ~HS; @(posedge clk);        
 		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
 		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b1; HS <= ~HS; @(posedge clk);        
 		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        
        HS <= ~HS; trigger <= 1'b0; @(posedge clk);
		for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        VS <= 1'b0; HS <= ~HS; @(posedge clk);
        for(i=0; i<10; i+=1) begin
			HS <= ~HS; @(posedge clk);
		end
        
		$stop;
	end
    
endmodule