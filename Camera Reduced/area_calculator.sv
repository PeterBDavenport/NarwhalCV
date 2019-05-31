module area_calculator (
    input logic [9:0] x0, y0, x1, y1,
    input logic start,
    input logic clk,
    output logic done,
    output logic [19:0] area,
    
    //connections to pixel cache
    output logic [9:0] x,       //location of pixel to read.
    output logic [9:0] y,       //location of pixel to read.
    input logic pixel,          // pixel (true or false), only valid when ready is asserted
    input logic ready           // true when pixel cache found pixel and outputs value
    );
    
    always_ff @(posedge clk) begin
        if(start) begin
            x <= x0;
            y <= y0;
            area <= '0;
            done <= 1'b0;
        end else begin
            // Only advance if we loaded the pixel at x, y.
            if(ready && !done) begin
                // Accumulate the area of this pixel.
                if(pixel) area <= area + 1;
                
                // Increment the scan across the bounding area.
                if(x >= x1) begin
                    x <= x0;
                    y <= y + 1;
                end else 
                    x <= x + 1;
                
                // Finish the process when we go past the end of
                // the bounding square.
                if(y > y1) done <= 1'b1;
            end
        end
    end
    
endmodule
/*
`timescale 1 ps / 1 ps
module area_calculator_testbench();

    // Shared Connections
    logic clk;
    logic reset;
    
    // connections to the area calculator.
    logic [9:0] x0, y0, x1, y1;
    logic start, done;
    logic [19:0] area;
    
    // Connections to pixel cache.
    logic [9:0] x, y;
    logic ready;
    logic pixel;
    logic  [7:0]  rdata;

    // Connecitons to the memory.
	logic         clock;
	logic [7:0]   data;
	logic [15:0]  rdaddress;
	logic [15:0]  wraddress;
	logic         wren;
	logic  [7:0]  q;
    
    image_memory image(	.clock, .data, .rdaddress, .wraddress, .wren, .q);
    
    area_calculator  dut(.x0, .y0, .x1, .y1, .start, .clk, .done,
                         .area, .x, .y, .pixel, .ready);
    
    pixel_cache  cache(.clk, .reset, .pixel, .ready, .x, .y, .rdaddress, .rdata);
    
    // Connect the signals from the other modules to the memory.
    assign rdata = q;
    assign clock = clk;
    
    // Set up the clock.
    parameter CLOCK_PERIOD=100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end
    
    initial begin
        reset <= 1'b1; @(posedge clk);
        reset <= 1'b0; @(posedge clk);

        // Load the memory with the following image
        //
        //               ( X )
        //         0123456789ABCDEF 
        //        #################
        //      0 #0000000000000000
        //      1 #0000000000000000
        //( Y ) 2 #0000000100000000  <- px at (7, 2)
        //      3 #0001000000000000  <- px at (3, 3)
        //      4 #0000000001000000  <- px at (9, 4)
        //      5 #0000010000000000  <- px at (5, 5)
        //      7 #0000000000000000
        //      8 #0000000000000000
        //      9 #0000000000000000
        //     10 #0000000000000000
        
        data <= 8'b10000000; wraddress <= 160; wren <= 1; @(posedge clk);
        data <= 8'b00001000; wraddress <= 240; wren <= 1; @(posedge clk);
        data <= 8'b00000010; wraddress <= 321; wren <= 1; @(posedge clk);
        data <= 8'b00100000; wraddress <= 400; wren <= 1; @(posedge clk);
        wren <= 0; @(posedge clk);
    
        start <= 0;
        x0 <= 0;
        y0 <= 0;
        x1 <= 9;
        y1 <= 9;

        // Compute the area.
        reset<=1; @(posedge clk);
        reset<=0; @(posedge clk);
        start<=1; @(posedge clk);
        start<=0; @(posedge clk);
        
        repeat(10*10*3) @(posedge clk);
        $stop;
    end
endmodule
*/