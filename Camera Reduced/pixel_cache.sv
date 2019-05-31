module pixel_cache #(parameter WIDTH = 640, parameter HEIGHT = 480)
(
    // User interface.
    input logic clk,     // Module clock.
    input logic reset,   // Module reset.
    output logic pixel,  // The value of the found pixel (valid when ready).
    output logic ready,  // The status of the pixel read.
    input logic [9:0] x,
    input logic [9:0] y,
    
    // Connection to the pixel memory.
    output logic [15:0] rdaddress,
    input logic  [7:0]  rdata
    );

    // The highest bit in ready_address indicates that no address is ready.
    // The ready_address signal either refers to the address which is ready,
    // or that no address is ready with ready_address = 17'b10000000000000000.
    reg  [16:0] ready_address;
    wire [16:0] requested_address;
    wire [7:0] px_data;
    assign ready = (ready_address == requested_address);
    assign px_data = (rdata >> (x%8));
    assign pixel = px_data[0];
    assign requested_address = (y*WIDTH/8) + (x>>3);
    assign rdaddress = requested_address[15:0];
    
    enum {S_idle, S_px_load} ps, ns;
    
    always_comb begin
        case (ps)
            S_idle:     ns = ready ? S_idle : S_px_load;
            S_px_load:  ns = S_idle;
        endcase
    end
    
    always_ff @(posedge clk)begin
        if(reset) begin
            ps <= S_idle;
            ready_address <= 17'b10000000000000000;
        end else begin
            ps <= ns;
            if(ps == S_px_load) ready_address <= requested_address;
        end
    end
    
endmodule

`timescale 1 ps / 1 ps
module pixel_cache_testbench();

    // image memory connections
	logic         clock;
	logic [7:0]   data;
	logic [15:0]  rdaddress;
	logic [15:0]  wraddress;
	logic         wren;
	logic  [7:0]  q;
    
    image_memory image(.*);
    
    // pixel cache connections.
    logic [9:0] x, y;
    logic clk, reset;
    logic pixel, ready;
    //logic [15:0] rdaddress;
    logic  [7:0]  rdata;
    
    assign rdata = q;
    
    pixel_cache cache(.*);

    parameter PERIOD = 100;
	initial begin
        clk <= 0;
        clock <= 0;
		forever #(PERIOD/2) begin
            clk <= ~clk;
            clock <= ~clock; 
        end
	end
    
    integer i, j;
	initial begin
        reset <= 1'b1; @(posedge clk);
        reset <= 1'b0; @(posedge clk);
        
        // Load the array with some values. Basically the following image
        // starting at the upper left corner of the screen array.
        //
        //               ( X )
        //         0123456789ABCDEF 
        //        #################
        //      0 #0000000010000000
        //      1 #0100000000100000
        //( Y ) 2 #0001000000001000
        //      3 #0000010000000010

        data <= 8'b00000000; wraddress <= 0; wren <= 1; @(posedge clk);
        data <= 8'b00000001; wraddress <= 1; @(posedge clk);
        data <= 8'b00000010; wraddress <= 80; @(posedge clk);
        data <= 8'b00000100; wraddress <= 81; @(posedge clk);
        data <= 8'b00001000; wraddress <= 160; @(posedge clk);
        data <= 8'b00010000; wraddress <= 161; @(posedge clk);
        data <= 8'b00100000; wraddress <= 240; @(posedge clk);
        data <= 8'b01000000; wraddress <= 241; @(posedge clk);
        wren <= 0; @(posedge clk);
        
            // Check that these values read where expected, nice incrementing pattern.
            for(j=0; j < 4; j++) begin
                for(i=0; i < 16; i++) begin

                x <= i; y <= j; @(posedge clk);
                while(!ready) @(posedge clk);
                
                if      (x == 8 && y == 0 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  1 && y == 1 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 10 && y == 1 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  3 && y == 2 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 12 && y == 2 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  5 && y == 3 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 14 && y == 3 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else
                    begin assert (pixel == 0 && ready) $display ("OK"); else $error("ERROR"); end
            end
        end

            // Check that these values read where expected, messy pattern.
            
            for(i=0; i < 16; i++) begin
                for(j=4; j > 0; j--) begin
            
                x <= i; y <= j; @(posedge clk);
                while(!ready) @(posedge clk);
                
                if      (x == 8 && y == 0 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  1 && y == 1 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 10 && y == 1 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  3 && y == 2 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 12 && y == 2 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x ==  5 && y == 3 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else if (x == 14 && y == 3 )
                    begin assert (pixel == 1 && ready) $display ("OK"); else $error("ERROR"); end
                else
                    begin assert (pixel == 0 && ready) $display ("OK"); else $error("ERROR"); end
            end
        end

		$stop;
	end
    
endmodule