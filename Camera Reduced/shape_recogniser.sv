/*
 * ################################################################################
 * ### shape_recogniser ###########################################################
 * ################################################################################
 *
 * ### MODULE OVERVIEW ###
 * This module takes in a VGA data stream, filters and transforms it into a bianary
 * array and then attempts to identify shapes (circles, squares, rectangles, and
 * triangles) in the image. When it finds a shape it will draw a bounding box around
 * it and then calculate vairous charectersistcs such as: area, centroid location,
 * corner locations, number of corners. These details can easily allow us to identify
 * the type of shape. When we recognise the type of shape we mark it's center with
 * colored cross hairs (RED for rectangles, GREEN for triangles, and BLUE for circles).
 * We will also play a sound effect when a shape is recognised, each one custom for
 * the shape in question.
 *
 *	### CONNECTIONS ###
 *  clk     - input  - Clock rate of the camera signal.
 *  reset   - input  - Reset the module into the waiting for trigger state.
 */

// NOTE: The property WIDTH*HEIGHT < 2^19 = 524,288 must be observed as this is
//       the total capacity of our memory for storing shape information.

module shape_recogniser #(parameter WIDTH = 640, parameter HEIGHT = 480)
(
   input logic VGA_CLK, // 25 MHz clock
   input logic reset,
   
   // *** Incoming VGA signals ***
   input logic [7:0] iVGA_B,         // Blue Signal, 0 when !iVGA_BLANK_N. Higher = brighter.
   input logic [7:0] iVGA_G,         // Green Signal, 0 when !iVGA_BLANK_N. Higher = brighter.
   input logic [7:0] iVGA_R,         // Red Signal, 0 when !iVGA_BLANK_N. Higher = brighter.
   input logic       iVGA_HS,        // Horizontal sync. Low between horizontal lines.
   input logic       iVGA_VS,        // Vertical sync. Low between video frames.
   input logic       iVGA_SYNC_N,    // Always zero.
   input logic       iVGA_BLANK_N,   // True in area not shown, false during the actual image.

   // *** Outgoing VGA signals ***
   output logic [7:0] oVGA_B,
   output logic [7:0] oVGA_G,
   output logic [7:0] oVGA_R,
   output logic       oVGA_HS,
   output logic       oVGA_VS,
   output logic       oVGA_SYNC_N,
   output logic       oVGA_BLANK_N,
   
   // *** Board outputs ***
   output logic [6:0] HEX0,
   output logic [6:0] HEX1,
   output logic [6:0] HEX2,
   output logic [6:0] HEX3,
   output logic [6:0] HEX4,
   output logic [6:0] HEX5,
   output logic [9:0] LEDR,

   // *** User inputs ***
   input logic [3:0] KEY, // Key[2] reserved for reset, key[3] for auto-focus.
   input logic [8:0] SW   // SW[9] reserved for auto-focus mode.
);

     // Set display outputs.
     assign LEDR = '0;

	 /* The following is responisble for displaying the shape detected to the
	  * seven segment display. Shape is only when detected.
	  */
	  logic circle, square, triangle;
	  assign circle = SW[0];
	  assign square = SW[1];
	  assign triangle = SW[2];
	  
	  display shape_detected(circle, 
									 square, 
									 triangle, 
									 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	  

    /*
     * The basic idea here is that we are being given a constant stream of video, or a frozen
     * frame of video looping over and over again, and we want to load this into an array to
     * save it. Then do some operations on this single frame of video data to be able to
     * identify shapes (black on white), draw bounding boxes around them, and then 
     */
    
    
    // Pixel Location Tracking.
    logic [12:0] x, y;
    pixel_counter location(.clk(VGA_CLK),
                           .reset,
                           .iVGA_HS,
                           .iVGA_VS,
                           .iVGA_BLANK_N,
                           .x_count(x),
                           .y_count(y));
    
    // RGB -> Boolean Transformation via brightness cutoff.
    wire pixel_darker_than_cutoff;
    assign pixel_darker_than_cutoff = ((iVGA_R < SW[7:0]) && (iVGA_G < SW[7:0]) && (iVGA_B < SW[7:0]));
    
    reg [9:0] right_x, left_x, top_y, bottom_y;
    reg [9:0] right_x_i, left_x_i, top_y_i, bottom_y_i;

    // Display Pass Through - Presentation to user.
    always_ff @(posedge VGA_CLK) begin
        if( (x == right_x) || (x == left_x) || (top_y == y) || (bottom_y == y))
            {oVGA_G, oVGA_B, oVGA_R} <= {8'h00, 8'h00, 8'hFF};
        else begin
            {oVGA_G, oVGA_B} <= {iVGA_G, iVGA_B};
            
            // Show the filtered verion in the center of the screen.
            if((WIDTH/4 < x)&&(x < WIDTH*3/4)&&(HEIGHT/4 < y)&&(y < HEIGHT*3/4)) begin
                oVGA_R <= pixel_darker_than_cutoff ? 8'h00 : 8'hFF;
            end else begin
                oVGA_R <= iVGA_R;
            end
        end

        {oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} <= {iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};
    end


   
    /* Boolean Value Recording.
     *  Here we are writing the stream of incoming pixels into the image memory.
     *  The idea is that we save a single frame of memory, that is 640 X 480 px.
     *  The image_memory has 2^19 = 524,288 bytes of capacity and we use 307,200
     *  of these bytes to store our "black and white" image of the shapes that
     *  we are trying to recognise.
     */
     
    // RAM module for boolean image memory.
    reg  [7:0]   write_data;
    wire [7:0]   outputData;
    reg  [15:0]  rdaddress;
    reg  [15:0]  wraddress;
    reg          write_en;
    image_memory image(.clock(VGA_CLK),
                        // Inputs
                       .data(write_data),
                       .wraddress(wraddress),
                       .wren(write_en),
                        // Outputs
                       .rdaddress(rdaddress),
                       .q(outputData));

    /*  Since our memory has a 8 bit word size we have 80 8-bit words per line
     *  and 480 lines of data. This means that the pixel at location (x, y) can
     *  be found at address = y*80 + x/8. This address gives a word containing
     *  the state (true, false) of eight seperate pixels side by side.
     
     *  To find the pixel itself we need to mask and shift the pixel out. The shift
     *  amount is given as shft_amt = x%8.
     */
    reg [8:0] px_write_buffer;
    always_ff @(posedge VGA_CLK) begin
        if(reset) begin
            px_write_buffer <= 0;
            write_en <= 0;
        end
        
        // Use the write data as a buffer to accumulate a full 8 bits of
        // data before sending it to the memory.
        px_write_buffer <= (pixel_darker_than_cutoff && iVGA_BLANK_N) | (px_write_buffer << 1);
        
        // Set the write address based on the coordinates.
        wraddress <= (y*(WIDTH/8)) + (x>>3);
        
        // Only record once every eight horizontal pixels.
        if(((x+1)%8) == 0 && (x > 0) && iVGA_BLANK_N) begin
            write_en <= 1'b1;
            write_data <= px_write_buffer[7:0];
        end else
            write_en <= 1'b0;
    end


/*
 * The algorithm controller will begin by finding the top edge,  right
 * edge, bottom edge, than left. From that it will load a small register
 * with the coordinates of the box. This will be used to draw the box.
 * ...
 *
 */

enum { S_IDLE,
       S_TOP, S_TOP_WAIT,
       S_RIGHT, S_RIGHT_WAIT, 
       S_BOTTOM, S_BOTTOM_WAIT,
       S_LEFT, S_LEFT_WAIT,
       S_AREA, S_AREA_WAIT, S_AREA_WAIT_2,
       S_DONE } ps, ns;

logic start_alogrithm;
logic edge_done;
logic edge_found; // TODO? Check when we dont find anything.
logic area_done;
logic [1:0] current_direction;
logic start_search;
logic start_area;

//search and area wires connect module to pixel cache through mux
//selected by case logic in ff block
logic [9:0] x_search_wire, y_search_wire;
logic [9:0] x_area_wire, y_area_wire;
logic [9:0] x_wire, y_wire;
wire pixel, ready;
logic [19:0] area, saved_area;

assign x_wire = (ps == S_AREA || ps == S_AREA_WAIT || ps == S_AREA_WAIT_2) ? x_area_wire : x_search_wire;
assign y_wire = (ps == S_AREA || ps == S_AREA_WAIT || ps == S_AREA_WAIT_2) ? y_area_wire : y_search_wire;

/* 
 * Algoritm trigger when KEY[1] goes from 1 -> 0.
 */
    logic algoritm_running;
    always_ff @(posedge VGA_CLK) begin
        if(reset)
            algoritm_running <= 0;
        else
            if(!KEY[1]) algoritm_running <= 1;            // Start the algoritm if the key is pressed.
    end


pixel_cache  #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) cache (.clk(VGA_CLK), .reset(reset), .pixel(pixel), .ready(ready), .x(x_wire), .y(y_wire), .rdaddress(rdaddress), .rdata(outputData));

edge_search  box(.search_x0(WIDTH/4), .search_y0(HEIGHT/4), .search_x1(WIDTH*3/4), .search_y1(HEIGHT*3/4), 
                     .start(start_search), .clk(VGA_CLK), .reset(reset), .search_direction(current_direction),
                     .done(edge_done), .found(edge_found), .x(x_search_wire), .y(y_search_wire), .pixel(pixel), .ready(ready));

area_calculator  shape(.x0(WIDTH/4), .y0(HEIGHT/4), .x1(WIDTH*3/4), .y1(HEIGHT*3/4), .start(start_area),
                       .clk(VGA_CLK), .done(area_done), .area(area), .x(x_area_wire), .y(y_area_wire), .pixel(pixel), .ready(ready));


always_comb begin
    case (ps) 
    S_IDLE          : begin
                        if(algoritm_running) ns = S_TOP;
                        else                ns = S_IDLE;
                      end
    S_TOP           :                       ns = S_TOP_WAIT; 
    S_TOP_WAIT      : begin 
                        if(edge_done)       ns = S_RIGHT;
                        else                ns = S_TOP_WAIT;
                      end
    S_RIGHT         :                       ns = S_RIGHT_WAIT;
    S_RIGHT_WAIT    : begin
                        if(edge_done)       ns = S_BOTTOM;
                        else                ns = S_RIGHT_WAIT;
                      end
    S_BOTTOM        :                       ns = S_BOTTOM_WAIT;
    S_BOTTOM_WAIT   : begin
                        if(edge_done)       ns = S_LEFT;
                        else                ns = S_BOTTOM_WAIT;
                      end
    S_LEFT          :                       ns = S_LEFT_WAIT;
    S_LEFT_WAIT     : begin
                        if(edge_done)       ns = S_AREA;
                        else                ns = S_LEFT_WAIT;
                      end
    S_AREA          :                       ns = S_AREA_WAIT;
    S_AREA_WAIT     :                       ns = S_AREA_WAIT_2;
    S_AREA_WAIT_2   : begin
                        if(area_done)       ns = S_DONE;
                        else                ns = S_AREA_WAIT_2;
                      end
    S_DONE          :                       ns = S_IDLE;
	 default         : 						     ns = S_IDLE;
    endcase
end

always_ff @(posedge VGA_CLK) begin
    if(reset)
        ps <= S_IDLE;
    else begin
        ps <= ns;
        case (ps) 
        S_IDLE          : begin
                          start_search <= '0;
                          start_area <= '0;
                          current_direction <= '0; 
                          end
        S_TOP           : begin
                            start_search <= 1;          //to find top, start at the top left 
                            current_direction <= 2'b01; //scan right than step down
                          end 
        S_TOP_WAIT      : begin 
                            start_search <= 0;
                            top_y_i <= y_search_wire;
                          end
        S_RIGHT         : begin                            
                            top_y <= top_y_i;
                            start_search <= 1;          //to find right, start at the top right 
                            current_direction <= 2'b10; //scan down than step left
                          end 
        S_RIGHT_WAIT    : begin 
                            start_search <= 0;
                            right_x_i <= x_wire;
                          end
        S_BOTTOM        : begin
                            right_x <= right_x_i;
                            start_search <= 1;          // Start at the bottom left 
                            current_direction <= 2'b00; // scan to the right than step up
                          end 
        S_BOTTOM_WAIT   : begin 
                            start_search <= 0;
                            bottom_y_i <= y_wire;
                          end
        S_LEFT          : begin
                            bottom_y <= bottom_y_i;
                            start_search <= 1;          // Start at the top right
                            current_direction <= 2'b11; // scan down than step right
                          end 
        S_LEFT_WAIT     : begin 
                            start_search <= 0;
                            left_x_i <= x_wire;
                          end
        S_AREA          : begin
                            left_x <= left_x_i;
                            start_area <= 1;
                          end
        S_AREA_WAIT     : start_area <= 0;
        S_DONE          : saved_area <= area;
        endcase
    end
end

endmodule

/*
 * ################################################################################
 * ### shape_recogniser_testbench #################################################
 * ################################################################################
 *
 * ### MODULE OVERVIEW ###
 * This module tests the shape recogniser.
 */

`timescale 1 ps / 1 ps
module shape_recogniser_testbench(); 
	// Can reduce width and height to speed up testing
	parameter WIDTH = 104;
	parameter HEIGHT = 104;
	parameter NUM_FRAMES = 5;  // We run until we've seen this many full video frames on the output.

	// Places to store the input image.  Set below.
	logic				[7:0]		inputR	[WIDTH-1:0][HEIGHT-1:0]; 
	logic				[7:0]		inputG	[WIDTH-1:0][HEIGHT-1:0]; 
	logic				[7:0]		inputB	[WIDTH-1:0][HEIGHT-1:0]; 
	// Place to store the output result.  Captured below.
	logic				[7:0]		outputR	[WIDTH-1:0][HEIGHT-1:0]; 
	logic				[7:0]		outputG	[WIDTH-1:0][HEIGHT-1:0]; 
	logic				[7:0]		outputB	[WIDTH-1:0][HEIGHT-1:0]; 
	
	// Connections to the DUT
	logic		          		VGA_CLK; // 25 MHz clock
    logic                       reset;
 
	// *** Incoming VGA signals ***
	// Colors.  0 if iVGA_BLANK_N is false.  Higher numbers brighter
	logic		     [7:0]		iVGA_B; // Blue
	logic		     [7:0]		iVGA_G; // Green
	logic		     [7:0]		iVGA_R; // Red
	// Horizontal sync.  Low between horizontal lines.
	logic		          		iVGA_HS;
	// Vertical sync.  Low between video frames.
	logic		          		iVGA_VS;
	// Always zero
	logic		          		iVGA_SYNC_N;
	// True in area not shown, false during the actual image.
 	logic		          		iVGA_BLANK_N;

	// *** Outgoing VGA signals ***
	logic		  [7:0]		oVGA_B;
	logic		  [7:0]		oVGA_G;
	logic		  [7:0]		oVGA_R;
	logic		       		oVGA_HS;
	logic		       		oVGA_VS;
	logic		       		oVGA_SYNC_N;
 	logic		       		oVGA_BLANK_N;
	
	// *** Board outputs ***
	logic		     [6:0]		HEX0;
	logic		     [6:0]		HEX1;
	logic		     [6:0]		HEX2;
	logic		     [6:0]		HEX3;
	logic		     [6:0]		HEX4;
	logic		     [6:0]		HEX5;
	logic		     [9:0]		LEDR;

	// *** User inputs ***
	logic		     [3:0]		KEY; // Key[2] reserved for reset, key[3] for auto-focus.
	logic		     [8:0]		SW;   // SW[9] reserved for auto-focus mode.
	
	shape_recogniser #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (.*);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		VGA_CLK <= 0;
		forever #(CLOCK_PERIOD/2) VGA_CLK <= ~VGA_CLK;
	end	
	
	// Set up a reset.  reset_n used for test bench, reset used for dut.
    // reset is active high, reset_n is active low.
	logic reset_n; // Active low (reset ON when reset == 0)
	initial begin
		KEY[2] <= 1'b0; reset_n <= 0; reset <= 1; @(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		KEY[2] <= 1'b1; reset_n <= 1; reset <= 0; 
	end	

	// Initialize the inputs to an obvious pattern
	initial begin
    
        // Draw a square.
		for (int i=0; i<WIDTH; i++) begin
			for (int j=0; j<HEIGHT; j++) begin
            inputG[i][j] = (i > 30) && (i < 60) && (j > 30) && (j < 60) ? 8'h00 : 8'hFF;
            inputR[i][j] = (i > 30) && (i < 60) && (j > 30) && (j < 60) ? 8'h00 : 8'hFF;
			inputB[i][j] = (i > 30) && (i < 60) && (j > 30) && (j < 60) ? 8'h00 : 8'hFF;
			end
		end
        
    /*    
        // Draw a triangle.
        for (int i=0; i<WIDTH; i++) begin
			for (int j=0; j<HEIGHT; j++) begin
                inputR[i][j] = (i > 25) && (j > 25) && (i < j) && (j <50) ? 8'h00 : 8'hFF;
				inputG[i][j] = (i > 25) && (j > 25) && (i < j) && (j <50) ? 8'h00 : 8'hFF;
				inputB[i][j] = (i > 25) && (j > 25) && (i < j) && (j <50) ? 8'h00 : 8'hFF;
			end
		end
        */
	end
	
	// Set up the user inputs.
	//assign KEY = '0;
	assign SW = 9'b00001111;
 
	// Parameters to config VGA.  Adapted from VGA_Param.h
	//	Horizontal Parameter	( Pixel )
	parameter	H_SYNC_CYC	=	96;
	parameter	H_SYNC_BACK	=	48;
	parameter	H_SYNC_ACT	=	WIDTH;	
	parameter	H_SYNC_FRONT=	16;
	parameter	H_SYNC_TOTAL=	H_SYNC_CYC + H_SYNC_BACK + H_SYNC_ACT + H_SYNC_FRONT;
	//	Vertical Parameter		( Line )
	parameter	V_SYNC_CYC	=	2;
	parameter	V_SYNC_BACK	=	33 ;
	parameter	V_SYNC_ACT	=	HEIGHT;	
	parameter	V_SYNC_FRONT=	10;
	parameter	V_SYNC_TOTAL=	V_SYNC_CYC + V_SYNC_BACK + V_SYNC_ACT + V_SYNC_FRONT;
	//	Start Offset
	//parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
	//parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
	parameter	H_BLANK	   =	H_SYNC_FRONT+H_SYNC_CYC+H_SYNC_BACK;
	parameter	V_BLANK	   =	V_SYNC_FRONT+V_SYNC_CYC+V_SYNC_BACK;

	// Set up the VGA timing signals.  Adapted from VGA_Controller.v
    logic		[12:0]		H_Cont; // Position horizontally
    logic		[12:0]		V_Cont; // Position vertically

	always_ff @(posedge VGA_CLK) begin
		if (!reset_n) begin
			H_Cont		<=	0;
		end else begin
			if ( H_Cont < H_SYNC_TOTAL - 1 )
				H_Cont	<=	H_Cont+1;
			else
				H_Cont	<=	0;
		end
	end

	always_ff @(posedge VGA_CLK) begin
		if (!reset_n) begin
			V_Cont		<=	0;
		end else begin
			if (H_Cont==H_SYNC_TOTAL - 1) begin 
				if( V_Cont < V_SYNC_TOTAL - 1 )
					V_Cont	 <=	V_Cont+1;
				else
					V_Cont	<=	0;
			end
		end
	end

	assign iVGA_BLANK_N	=   ~((H_Cont < H_BLANK ) || ( V_Cont < V_BLANK ));
	assign iVGA_HS =	( ( H_Cont > (H_SYNC_FRONT ) )  &&  ( H_Cont <= (H_SYNC_CYC + H_SYNC_FRONT)))? 0 : 1; 
	assign iVGA_VS =	( ( V_Cont > (V_SYNC_FRONT ) )  &&  ( V_Cont <= (V_SYNC_CYC + V_SYNC_FRONT)))? 0 : 1; 
	assign iVGA_SYNC_N =	 1'b0   ;
	assign iVGA_R	 =	 iVGA_BLANK_N ?	inputR[H_Cont-H_BLANK][V_Cont-V_BLANK]	   :	0;
	assign iVGA_G	 =	 iVGA_BLANK_N ?	inputG[H_Cont-H_BLANK][V_Cont-V_BLANK]		:	0;
	assign iVGA_B	 =	 iVGA_BLANK_N ?	inputB[H_Cont-H_BLANK][V_Cont-V_BLANK]	   :	0;  
 
	// Capture the output.
   logic		[12:0]		out_x; // Position horizontally
   logic		[12:0]		out_y; // Position vertically

	always_ff @(posedge VGA_CLK) begin
		//assert(!reset_n || oVGA_SYNC_N == 0);
		if (!reset_n) begin
			out_x <= 0;
			out_y <= 0;
			// Ignore everything if in reset period.
		end else if (!oVGA_BLANK_N) begin // When we should be off
			//assert(oVGA_R == 0 && oVGA_G == 0 && oVGA_B == 0);
			if (!oVGA_VS) begin // Reset on vsync.
				out_x <= 0;
				out_y <= 0;
			end
			//assert(out_x <= WIDTH);
			//assert(out_y <= HEIGHT);
		end else begin
			outputR[out_x][out_y] <= oVGA_R;
			outputG[out_x][out_y] <= oVGA_G;
			outputB[out_x][out_y] <= oVGA_B;
			if (out_x < WIDTH-1)
				out_x <= out_x + 1;
			else begin
				out_x <= 0;
				out_y <= out_y + 1;
			end
		end
	end
	
	// Run until we've sent enough video frames.
	int frames_seen;
	logic prev_iVGA_VS;
	always_ff @(posedge VGA_CLK) begin
		if (!reset_n) begin
			frames_seen <= 0;
            KEY[1] <= 1'b1;
		end else if (prev_iVGA_VS && !iVGA_VS) begin
			if (frames_seen == NUM_FRAMES) $stop();
            if (frames_seen == 1) KEY[1] <= 1'b0;
			frames_seen <= frames_seen + 1;
		end
		prev_iVGA_VS <= iVGA_VS;
	end
	
endmodule