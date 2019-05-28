module pixel_cache (input logic x,
                    input logic y,
                    input logic request,
                    output logic pixel,
                    output logic ready,
                    output logic [15:0]  rdaddress,
                    input logic  [7:0]   rdata
                    );

endmodule

module bounding_box_finder(input logic [9:0] search_x0, search_x1, search_y0, search_y1, // Search rectangle
                           input logic start, clk, reset,
                           output logic [9:0] bounding_x0, bounding_x1, bounding_y0, bounding_y1, // Bounding rectange
                           output logic done);

endmodule

module edge_search(input logic [9:0] start_x, start_y, search_width, search_height,
                   input logic start, clk, reset,
                   input logic [1:0] search_direction,
                   output logic [9:0] found_x, found_y,
                   output logic done);

endmodule

module get_area(input logic [9:0] bounding_x0, bounding_x1, bounding_y0, bounding_y1,
                input logic start, clk, reset,
                output logic done,
                output logic [19:0] area);

endmodule


module bounding_box_testbench();

    // RAM module for boolean image memory.
    reg [7:0]   write_data;
    reg [7:0]   outputData;
    reg [15:0]  rdaddress;
    reg [15:0]  wraddress;
    reg write_en;
    image_memory image(.clock(VGA_CLK),
                       .data(write_data),
                       .rdaddress(rdaddress),
                       .wraddress(wraddress),
                       .wren(write_en),
                       .q(outputData));
                       
    pixel_cache (input logic x,
                    input logic y,
                    input logic request,
                    output logic pixel,
                    output logic ready);

    bounding_box_finder(input logic [9:0] search_x0, search_x1, search_y0, search_y1, // Search rectangle
                           input logic start, clk, reset,
                           output logic [9:0] bounding_x0, bounding_x1, bounding_y0, bounding_y1, // Bounding rectange
                           output logic done);
endmodule