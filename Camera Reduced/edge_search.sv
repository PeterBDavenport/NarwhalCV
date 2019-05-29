module edge_search(
    input logic [9:0] search_x0,
    input logic [9:0] search_y0,
    input logic [9:0] search_x1,
    input logic [9:0] search_y1,
    input logic start,
    input logic clk,
    input logic reset,
    input logic [1:0] search_direction,
    output logic done,
    output logic found,

    //connections to pixel cache
    output logic [9:0] x,       //location of pixel to read.
    output logic [9:0] y,       //location of pixel to read.
    input logic pixel,          // pixel (true or false), only valid when ready is asserted
    input logic ready           // true when pixel cache found pixel and outputs value
    );

    enum {IDLE, LOAD, REQ_PIXEL, WAIT_FOR_PX, EVAL_PIXEL, FINISHED} ps, ns;
    enum {UP, DOWN, LEFT, RIGHT} direction;

    //location of current pixel begin evaluated
    logic [10:0] x_count, y_count;
    logic outside_of_search_frame;
    
    assign outside_of_search_frame = (x_count > search_x1) || (x_count < search_x0)
                                  || (y_count > search_y1) || (y_count < search_y0);

    //define derection from input, this is fixed
    //for the module and should not change
    always_comb begin
        case(search_direction)
            2'b00 : direction = UP;
            2'b01 : direction = DOWN;
            2'b10 : direction = LEFT;
            2'b11 : direction = RIGHT;
        endcase
    end

    //drives the state machine
    always_comb begin
        case(ps)
            IDLE: begin
                    if(start)   ns = LOAD;
                    else        ns = IDLE;
                end
            LOAD:               ns = REQ_PIXEL;
            REQ_PIXEL:          ns = WAIT_FOR_PX;
            WAIT_FOR_PX: begin
                    if(ready)   ns = EVAL_PIXEL;
                    else        ns = REQ_PIXEL;
                end
            EVAL_PIXEL: begin
                    // End if we find the pixel or run out of frame.
                    if(pixel || outside_of_search_frame) ns = FINISHED;
                    else        ns = REQ_PIXEL;
                end
            FINISHED: begin
                    if (start)  ns = LOAD;
                    else        ns = FINISHED;
                end
        endcase
    end

    always_ff @(posedge clk) begin
        if(reset)
            ps <= IDLE;
        else begin
            ps <= ns;
            
            case(ps)
                IDLE: begin
                    done    <= '0;
                    found   <= '0;
                    x       <= '0;
                    y       <= '0;
                end
                LOAD: begin
                    // We need to start the search in the appropriate corner.
                    // All searches are left to right except for LEFT which is
                    // right to left. All searches are top to bottom except UP
                    // which is bottom to top.
                    case (direction)
                        UP : begin  // Start at the bottom left.
                            x_count <= search_x0;
                            y_count <= search_y1;
                        end
                        DOWN : begin // Start at the top left.
                            x_count <= search_x0;
                            y_count <= search_y0;                            
                        end
                        RIGHT : begin // start at the top left.
                            x_count <= search_x0;
                            y_count <= search_y0; 
                        end
                        LEFT : begin // start at the top right.
                            x_count <= search_x1;
                            y_count <= search_y0; 
                        end
                    endcase
                end
                REQ_PIXEL: begin
                    x <= x_count;
                    y <= y_count;
                end
                EVAL_PIXEL: begin                    
                    // Continue the search pattern.
                    case (direction)
                        UP : // Start at the bottom left.
                             // Scan to the right, incrementing each row.
                            if(x_count == search_x1) begin
                                y_count <= y_count - 1; // Move up in y after each row.
                                x_count <= search_x0; // Reset to the left side.
                            end else
                                x_count <= x_count + 1; // Step to the right.

                        DOWN: // Start at the top left.
                              // Scan to the right, decrementing each row.
                            if(x_count == search_x1) begin
                                y_count <= y_count + 1;
                                x_count <= search_x0;
                            end else
                                x_count <= x_count + 1;
                        
                        RIGHT: // Start at the top left.
                               // Scan down then step right.
                            if(y_count == search_y1) begin
                                y_count <= search_y0;
                                x_count <= x_count + 1;
                            end else
                                y_count <= y_count + 1;
                        
                        LEFT: // start at the top right.
                              // Scan down then step left.
                            if(y_count == search_y1) begin
                                y_count <= search_y0;
                                x_count <= x_count - 1;
                            end else
                                y_count <= y_count + 1;
                        
                    endcase
                end
                FINISHED: begin
                    done    <= 1'b1;
                    found   <= !outside_of_search_frame;
                end
            endcase
        end
    end
endmodule

`timescale 1 ps / 1 ps
module edge_search_testbench();

    // Shared Connections
    logic clk;
    logic reset;

    // Connections to the searcher.
    logic [9:0] search_x0, search_y0, search_x1, search_y1;
    logic start;
    logic [1:0] search_direction;
    logic done;
    logic found;
    
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
    
    edge_search  dut(.search_x0, .search_y0, .search_x1, .search_y1, .start,
                     .clk, .reset, .search_direction,
                     .done, .found, .x, .y, .pixel, .ready);
    
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
    
    integer i, j, dir;
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
        search_x0 <= 0;
        search_y0 <= 0;
        search_x1 <= 9;
        search_y1 <= 9;

        // Searches that complete
        for(dir=0;dir<4;dir++) begin
            search_direction <= dir;
            reset<=1; @(posedge clk);
            reset<=0; @(posedge clk);
            start<=1; @(posedge clk);
            start<=0; @(posedge clk);
            
            repeat(10*10*3) @(posedge clk);
        end
        
        $stop;
    end
endmodule