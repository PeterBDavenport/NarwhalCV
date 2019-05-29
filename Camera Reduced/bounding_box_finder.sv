module pixel_cache (input logic [9:0] x, y,
                    input logic request, clk, reset,
                    output logic pixel, ready,
                    output logic [15:0] rdaddress,
                    input logic  [7:0]  rdata);

    wire [15:0] read_address;
    wire [7:0] bit_mask;
    assign bit_mask = 8'b10000000 >> (x%8);    
    assign read_address = (y*80) + (x>>3);
    
    enum {S_loading_data, S_data_loaded} ps, ns;
    
    always_comb begin
        /*case (ps)
            S_loading_data:
                
            S_data_loaded:
                
        endcase*/
    end
    
    always_ff @(posedge clk)begin
        if(reset)
            ps <= S_loading_data;
        else
            ps <= ns;
    end
    
endmodule

module bounding_box_finder(input logic [9:0] search_x0, search_x1, search_y0, search_y1, // Search rectangle
                           input logic start, clk, reset,
                           output logic [9:0] bounding_x0, bounding_x1, bounding_y0, bounding_y1, // Bounding rectange
                           output logic done,
                   
                   // Connections to pixel_cache
                   output logic [9:0] x, y, // location of pixel to read.
                   output logic request,    // request a new pixel.
                   input logic pixel,       // The pixel (true or false), only valid when ready is asserted.
                   input logic ready        // 
                           );

endmodule

module edge_search(input logic [9:0] start_x, start_y, search_width, search_height,
                   input logic start, clk, reset,
                   input logic [1:0] search_direction,
                   output logic [9:0] found_x, found_y,
                   output logic done,
                   
                   output logic [9:0] x, y,
                   output logic request,
                   input logic pixel, ready
                   );

endmodule

module get_area(input logic [9:0] bounding_x0, bounding_x1, bounding_y0, bounding_y1,
                input logic start, clk, reset,
                output logic done,
                output logic [19:0] area);

endmodule

`timescale 1 ps / 1 ps
module bounding_box_finder_testbench();

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
    logic request, clk, reset;
    logic pixel, ready;
    //logic [15:0] rdaddress;
    logic  [7:0]  rdata;
    
    pixel_cache cache(.*);

    parameter PERIOD = 100;
	initial begin
        clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
    
    integer i;
	initial begin
        for(i=0; i<100; i+=1) begin
			data <= i;
            wraddress <= i;
            @(posedge clk);
		end
		$stop;
	end
    
endmodule