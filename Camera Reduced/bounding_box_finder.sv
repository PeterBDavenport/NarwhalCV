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