/*
 * ################################################################################
 * ### pixel_counter ##############################################################
 * ################################################################################
 *
 * ### MODULE OVERVIEW ###
 * This module takes in a VGA data stream and uses these signals to track which
 * pixel position was last in the stream. At any point when BLANK_N is high the
 * x_count and y_count values are the locaiton of the color shown on VGA_R/G/B
 * respectively at these coordinates.
 *
 *	### CONNECTIONS ###
 *  clk          - input  - Clock rate of the camera signal.
 *  reset        - input  - Reset this module.
 *  iVGA_HS      - input  - VGA horizontal sync signal, low between horizontal lines.
 *  iVGA_VS      - input  - VGA vertical sync signal, low between frames.
 *  iVGA_BLANK_N - input  - VGA blank signal, the color values are only valid
 *                          when this is asserted.
 *  x_count      - output - x position of this or the last pixel.
 *  y_count      - output - y position of this or the last pixel.
 */
module pixel_counter(
	input logic clk,
	input logic reset, 
	input logic iVGA_HS,
	input logic iVGA_VS,
    input logic iVGA_BLANK_N,
   output logic [12:0] x_count,
   output logic [12:0] y_count);
	
    // Internal state.
    reg new_frame;
    reg iVGA_BLANK_N_last_clk;
    
    // Position tracking.
	always_ff @(posedge clk) begin
        iVGA_BLANK_N_last_clk <= iVGA_BLANK_N;
    
        if(reset || !iVGA_VS) begin
			x_count <= 13'b0;
			y_count <= 13'b0;
            new_frame <= 1'b1;
        end else begin
            // The horizontal pixels are only valid when
            // both HS and BLANK_N are high.
            if(iVGA_HS && iVGA_BLANK_N) begin
                x_count <= x_count + 13'b1;
            end
            
            // The line count (y) only increments on the
            // first falling edge of BLANK_N after a new_frame
            if(new_frame && iVGA_BLANK_N_last_clk && !iVGA_BLANK_N) begin
                x_count <= 13'b0;
                y_count <= y_count + 13'b1;
            end
        end
	end

endmodule