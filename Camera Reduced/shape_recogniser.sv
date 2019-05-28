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

    /*
     * The basic idea here is that we are being given a constant stream of video, or a frozen
     * frame of video looping over and over again, and we want to load this into an array to
     * save it. Then do some operations on this single frame of video data to be able to
     * identify shapes (black on white), draw bounding boxes around them, and then 
     */
    
   reg [7:0]   inputData;
   reg [7:0]   outputData;
   reg [15:0]  rdaddress;
   reg [15:0]  wraddress;
   reg write_en;
   image_memory image(.clock(VGA_CLK),
                      .data(inputData),
                      .rdaddress(rdaddress),
                      .wraddress(wraddress),
                      .wren(write_en),
                      .q(outputData));
    
    /* Video input stream.
     *  Here we are writing the stream of incoming pixels into the image memory.
     *  The idea is that we save a single frame of memory, that is 640 X 480 px.
     *  The image_memory has 2^19 = 524,288 bytes of capacity and we use 307,200
     *  of these bytes to store our "black and white" image of the shapes that
     *  we are trying to recognise.
     *
     *  Since our memory has a 8 bit word size we have 80 8-bit words per line
     *  and 480 lines of data. This means that the pixel at location (x, y) can
     *  be found at address = y*480*80 + x/8. This address gives a word containing
     *  the state (true, false) of eight seperate pixels side by side.
     *  To find the pixel itself we need to mask and shift the pixel out. The shift
     *  amount is given as shft_amt = x%8 = x - ((x>>3)<<3).
     */
    
    // Pixel Location Tracking.
    logic [12:0] x_count, y_count;
    pixel_counter location(.clk(VGA_CLK),
                           .reset,
                           .iVGA_HS,
                           .iVGA_VS,
                           .iVGA_BLANK_N,
                           .x_count,
                           .y_count);
    
    // RGB -> Boolean Transformation via brightness cutoff.
    wire pixel_darker_than_cutoff;
    assign pixel_darker_than_cutoff = ((iVGA_R < SW[7:0]) && (iVGA_G < SW[7:0]) && (iVGA_B < SW[7:0]));

   // Display Pass Through
   always_ff @(posedge VGA_CLK) begin
    // Show the filtered verion in the center of the screen.
    if( (WIDTH/4 < x_count)&&(x_count < WIDTH*3/4)
      &&(HEIGHT/4 < y_count)&&(y_count < HEIGHT*3/4)) begin
        oVGA_R <= pixel_darker_than_cutoff ? 8'h00 : 8'hFF;
    end else begin
        oVGA_R <= iVGA_R;
    end
    
    {oVGA_G, oVGA_B} <= {iVGA_G, iVGA_B};
    {oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} <= {iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};
   end
   
   // Boolean Value Recording.

    /*
    reg [7:0] load_progress;
    always_ff @(posedge VGA_CLK) begin
        if(reset)
            load_progress <= 0;
        else begin
            // For testing lets load the first 100 entries with values.
            if(load_progress < 10) begin
                load_progress <= load_progress + 1;
                wraddress <= load_progress;
                inputData <= load_progress + 7;
                write_en <= 1;
            end else begin
                wraddress <= 0;
                inputData <= 0;
                write_en <= 0;
            end            
        end
    end
    
    // Output from saved input stream.
    reg [7:0] read_progress;
    always_ff @(posedge VGA_CLK) begin
        if(reset)
            read_progress <= 0;
        else begin
            // For testing lets load the first 100 entries with values.
            if(load_progress >= 10) begin
                read_progress <= read_progress + 1;
                rdaddress <= read_progress;
            end
        end
    end
    */
    /*
   // Simple graphics hack
   logic bw_image;
   logic [12:0] x, y;
   assign bw_pixel = ((iVGA_R > SW[7:0]) && (iVGA_G > SW[7:0]) && (iVGA_B > SW[7:0]));
   
   // Array of black and white values
   //                -x-         -y-
   reg [WIDTH-1:0] bw_array [HEIGHT-1:0];
   
   // Find the X/Y position
   //pixel_counter count(.clk(VGA_CLK), .reset(~KEY[2]), .iVGA_HS(iVGA_HS), .iVGA_VS(iVGA_VS), .x_count(x), .y_count(y));
   
   // Memory for storing the black and white image of the thing in question.
   image_memory image(.clock(VGA_CLK),   .data(), .rdaddress(), .wraddress(), .wren(), .q());
   //input     clock;
   //input   [7:0]  data;
   //input   [15:0]  rdaddress;
   //input   [15:0]  wraddress;
   //input     wren;
   //output   [7:0]  q;
   
   always_ff @(posedge VGA_CLK) begin
      // Normally we fill the array, print normal colors.
      if(KEY[1]) begin
         //bw_array[x][y] <= bw_pixel;
         {oVGA_R, oVGA_G, oVGA_B} <= {iVGA_R, iVGA_G, iVGA_B};
         {oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} <= {iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};   
      end else begin
         // But when SW[2] is pressed we show the contents of bw_array.
         oVGA_R <= bw_pixel ? 8'h00 : 8'hFF;
         {oVGA_G, oVGA_B} <= {iVGA_G, iVGA_B};
         {oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} <= {iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};
      end
   end
   */
   
   // Set display outputs.
   assign HEX0 = '1;
   assign HEX1 = '1;
   assign HEX2 = '1;
   assign HEX3 = '1;
   assign HEX4 = '1;
   assign HEX5 = '1;
   assign LEDR = '0;
endmodule

/*
module shape_recogniser_testbench();
    logic       VGA_CLK, clk, reset;
    logic [7:0] iVGA_B, iVGA_G, iVGA_R;
    logic       iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N;
    logic [7:0] oVGA_B, oVGA_G, oVGA_R;
    logic       oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [3:0] KEY;
    logic [8:0] SW;

    assign VGA_CLK = clk;
    
    shape_recogniser #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (.*);
    
    parameter PERIOD = 100;
	initial begin
        clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end

integer i;
	initial begin
        // Test: Simulate an incoming signal 
    
        {iVGA_R, iVGA_G, iVGA_B, iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N} <= '1;
        reset <= 0; @(posedge clk);
        reset <= 1; @(posedge clk);
        reset <= 0; @(posedge clk);
		for(i=0; i<100; i+=1) begin
			 @(posedge clk);
		end
        $stop;
    end

endmodule
*/

`timescale 1 ps / 1 ps
module shape_recogniser_testbench();
	// Can reduce width and height to speed up testing
	parameter WIDTH = 10;
	parameter HEIGHT = 10;
	parameter NUM_FRAMES = 2;  // We run until we've seen this many full video frames on the output.

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
		reset_n <= 0; reset <= 1; @(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		reset_n <= 1; reset <= 0; 
	end	

	// Initialize the inputs to an obvious pattern
	initial begin
		for (int i=0; i<WIDTH; i++) begin
			for (int j=0; j<HEIGHT; j++) begin
				inputR[i][j] = i;
				inputG[i][j] = j;
				inputB[i][j] = i+j;
			end
		end
	end
	
	// Set up the user inputs.
	assign KEY = '0;
	assign SW = '0;
 
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
		assert(!reset_n || oVGA_SYNC_N == 0);
		if (!reset_n) begin
			out_x <= 0;
			out_y <= 0;
			// Ignore everything if in reset period.
		end else if (!oVGA_BLANK_N) begin // When we should be off
			assert(oVGA_R == 0 && oVGA_G == 0 && oVGA_B == 0);
			if (!oVGA_VS) begin // Reset on vsync.
				out_x <= 0;
				out_y <= 0;
			end
			assert(out_x <= WIDTH);
			assert(out_y <= HEIGHT);
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
		end else if (prev_iVGA_VS && !iVGA_VS) begin
			if (frames_seen == NUM_FRAMES) $stop();
			frames_seen <= frames_seen + 1;
		end
		prev_iVGA_VS <= iVGA_VS;
	end
	
endmodule