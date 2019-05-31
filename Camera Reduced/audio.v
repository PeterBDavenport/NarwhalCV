module audio (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [8:0] SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	
	reg read_ready, write_ready, read, write;
	reg [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	
	always begin 
		if(write_ready && read_ready) begin
			writedata_left = readdata_left;
			writedata_right = readdata_right;
			write = 1'b1;
			read  = 1'b1;
		end else begin
			writedata_left = 0;
			writedata_right = 0;
			write = 1'b0;
			read  = 1'b0;
		end
	end
//	
////=============================================================================
//// SD RAM for audio recording
////=============================================================================
//
//wire	[15:0]SDRAM_RD_DATA;
//wire			DLY_RST_0;
//wire			DLY_RST_1;
//wire			DLY_RST_2;
//
//wire			SDRAM_CTRL_CLK;
//wire        D8M_CK_HZ ; 
//wire        D8M_CK_HZ2 ; 
//wire        D8M_CK_HZ3 ; 
//
////------SDRAM CLOCK GENNERATER  --
//sdram_pll u6(
//		               .areset( 0 ) ,     
//		               .inclk0( CLOCK_50 ),              
//		               .c1    ( DRAM_CLK ),       //100MHZ   -90 degree
//		               .c0    ( SDRAM_CTRL_CLK )  //100MHZ     0 degree 							
//		              
//	               );		
//						
////------SDRAM CONTROLLER --
//Sdram_Control	   u7A	(	//	HOST Side						
//						   .RESET_N     ( SW[8] ),
//							.CLK         ( SDRAM_CTRL_CLK ) , 
//							//	FIFO Write Side 1
//							.WR1_DATA    ( writedata_left[23:0] ),
//							.WR1         ( !KEY[0] ) ,
//							
//							.WR1_ADDR    ( 0 ),
//                     .WR1_MAX_ADDR( 2*24 ),
//						   .WR1_LENGTH  ( 25 ) , 
//		               .WR1_LOAD    ( !DLY_RST_0 ),
//							.WR1_CLK     ( AUD_XCK),
//
//                     //	FIFO Read Side 1
//						   .RD1_DATA    ( SDRAM_RD_DATA[9:0] ),
//				        	.RD1         ( READ_Request ),
//				        	.RD1_ADDR    (0 ),
//                     .RD1_MAX_ADDR( 2*24  ),
//							.RD1_LENGTH  ( 25 ),
//							.RD1_LOAD    ( !DLY_RST_1 ),
//							.RD1_CLK     ( AUD_XCK ),
//											
//							//	SDRAM Side
//						   .SA          ( DRAM_ADDR ),
//							.BA          ( DRAM_BA ),
//							.CS_N        ( DRAM_CS_N ),
//							.CKE         ( DRAM_CKE ),
//							.RAS_N       ( DRAM_RAS_N ),
//							.CAS_N       ( DRAM_CAS_N ),
//							.WE_N        ( DRAM_WE_N ),
//							.DQ          ( DRAM_DQ ),
//							.DQM         ( DRAM_DQM  )
//						   );
//	

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule
