// Warning: the Terasic VGA controller appears to have a few off-by-one errors.  If your code is very 
// sensitive to the EXACT number of pixels per line, you may have issues.  You have been warned!

module Filter #(parameter WIDTH = 640, parameter HEIGHT = 480)
(
	input logic		          		VGA_CLK, // 25 MHz clock
 
	// *** Incoming VGA signals ***
	// Colors.  0 if iVGA_BLANK_N is false.  Higher numbers brighter
	input logic		     [7:0]		iVGA_B, // Blue
	input logic		     [7:0]		iVGA_G, // Green
	input logic		     [7:0]		iVGA_R, // Red
	// Horizontal sync.  Low between horizontal lines.
	input logic		          		iVGA_HS,
	// Vertical sync.  Low between video frames.
	input logic		          		iVGA_VS,
	// Always zero
	input logic		          		iVGA_SYNC_N,
	// True in area not shown, false during the actual image. v    
 	input logic		          		iVGA_BLANK_N,

	// *** Outgoing VGA signals ***
	output logic		  [7:0]		oVGA_B,
	output logic		  [7:0]		oVGA_G,
	output logic		  [7:0]		oVGA_R,
	output logic		       		oVGA_HS,
	output logic		       		oVGA_VS,
	output logic		       		oVGA_SYNC_N,
 	output logic		       		oVGA_BLANK_N,
	
	// *** Board outputs ***
	output logic		     [6:0]		HEX0,
	output logic		     [6:0]		HEX1,
	output logic		     [6:0]		HEX2,
	output logic		     [6:0]		HEX3,
	output logic		     [6:0]		HEX4,
	output logic		     [6:0]		HEX5,
	output logic		     [9:0]		LEDR,

	// *** User inputs ***
	input logic 		     [1:0]		KEY, // Key[2] reserved for reset, key[3] for auto-focus.
	input logic			     [8:0]		SW   // SW[9] reserved for auto-focus mode.
);

	// Simple graphics hack
	logic [27:0] delay [1:0];
	logic [7:0] delta_R;
	logic [7:0] delta_G;
	logic [7:0] delta_B;
	logic [27:0] prev_delay0;

	// Before and after delays.
	always_ff @(posedge VGA_CLK) begin
		{oVGA_R, oVGA_G, oVGA_B, oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} <= delay[1];
		prev_delay0 <= delay[0];
		delay[0] <= {iVGA_R, iVGA_G, iVGA_B, iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};
	end
	
	always_comb begin
		if (delay[0][27:20] > prev_delay0[27:20])
			delta_R = delay[0][27:20] - prev_delay0[27:20];
		else
			delta_R = prev_delay0[19:12] - delay[0][19:12];
		if (delay[0][19:12] > prev_delay0[19:12])
			delta_G = delay[0][19:12] - prev_delay0[19:12];
		else
			delta_G = prev_delay0[11:4] - delay[0][11:4];
		if (delay[0][11:4] > prev_delay0[11:4])
			delta_B = delay[0][11:4] - prev_delay0[11:4];
		else
			delta_B = prev_delay0[11:4] - delay[0][11:4];
	end
	
	always_ff @(posedge VGA_CLK) begin
		delay[1] <= delay[0];
		if (SW[0]) delay[1][27:20] = delta_R;
		if (SW[1]) delay[1][19:12] = delta_G;
		if (SW[2]) delay[1][11:4] = delta_B;
	end
	
	/*
	// Variable length delay.  0 or more.  Inserts NUM_DELAYS registers.
	localparam NUM_DELAYS = 100;
	logic [27:0] delay [NUM_DELAYS:0];

	assign {oVGA_R, oVGA_G, oVGA_B, oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N} = delay[NUM_DELAYS];
	assign delay[0] = {iVGA_R, iVGA_G, iVGA_B, iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N};
	
	always_ff @(posedge VGA_CLK) begin
		for (int i=NUM_DELAYS-1; i>=0; i--) begin
			delay[i+1] <= delay[i];
		end
	end
	*/
	
	/*
	// Straight cut-through
	assign oVGA_R = iVGA_R;
	assign oVGA_G = iVGA_G;
	assign oVGA_B = iVGA_B;
	assign oVGA_HS = iVGA_HS;
	assign oVGA_VS = iVGA_VS;
	assign oVGA_SYNC_N = iVGA_SYNC_N;
	assign oVGA_BLANK_N = iVGA_BLANK_N;
	*/
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = '0;

endmodule

module Filter_testbench ();
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
	logic		     [1:0]		KEY; // Key[2] reserved for reset, key[3] for auto-focus.
	logic		     [8:0]		SW;   // SW[9] reserved for auto-focus mode.
	
	Filter #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) dut (.*);

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		VGA_CLK <= 0;
		forever #(CLOCK_PERIOD/2) VGA_CLK <= ~VGA_CLK;
	end	
	
	// Set up a reset.  Not used by DUT, but helpful below.
	logic reset_n; // Active low (reset ON when reset == 0)
	initial begin
		reset_n <= 0;
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		@(posedge VGA_CLK);
		reset_n <= 1;
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
	
	// Run until we've seen enough video frames.
	int frames_seen;
	logic prev_oVGA_VS;
	always_ff @(posedge VGA_CLK) begin
		if (!reset_n) begin
			frames_seen <= 0;
		end else if (prev_oVGA_VS && !oVGA_VS) begin
			if (frames_seen == NUM_FRAMES) $stop();
			frames_seen <= frames_seen + 1;
		end
		prev_oVGA_VS <= oVGA_VS;
	end
	
endmodule
