module edge_search(
    input logic [9:0] search_x0,
    input logic [9:0] search_y0,
    input logic [9:0] search_x1,
    input logic [9:0] search_y1,
    input logic start,
    input logic clk,
    input logic reset,
    input logic [1:0] search_direction,
    output logic [9:0] found_x,
    output logic [9:0] found_y,
    output logic done,
    output logic found,

    //connections to pixel cache
    output logic [9:0] x,       //location of pixel to read.
    output logic [9:0] y,       //location of pixel to read.
    output logic request,       //request a new pixel
    input logic pixel,          // pixel (true or false), only valid when ready is asserted
    input logic ready           // true when pixel cache found pixel and outputs value
    );

    enum {IDLE, LOAD, REQ_PIXEL, EVAL_PIXEL, FINISHED} ps, ns;
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
            REQ_PIXEL: begin
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
                    found_x <= '0;
                    found_y <= '0; 
                    done    <= '0;
                    found   <= '0;
                end
                LOAD: begin
                    // We need to start the search in the appropriate corner.
                    // All searches are left to right except for LEFT which is
                    // right to left. All searches are top to bottom except UP
                    // which is bottom to top.
                    x_count <= (direction == LEFT) ? search_x1 : search_x0;
                    y_count <= (direction == UP) ? search_y1 : search_y0;
                end
                REQ_PIXEL: begin
                    request <= 1;
                    x <= x_count;
                    y <= y_count;
                end
                EVAL_PIXEL: begin                    
                    // Continue the search pattern.
                    case (direction)
                        UP : // Starting in bottom left corner, scanning up then right.
                            if(y_count == search_y0) begin
                                y_count <= search_y1;
                                x_count <= x_count + 1;
                            end else
                                y_count <= y_count - 1;
                        
                        DOWN: // Starting in top left corner, scanning down, then right.
                            if(y_count == search_y1) begin
                                y_count <= search_y0;
                                x_count <= x_count + 1;
                            end else
                                y_count <= y_count + 1;
                        
                        LEFT: // Starting in top right corner, scanning left then down.
                            if(x_count == search_x0) begin
                                x_count <= search_x1;
                                y_count <= y_count + 1;
                            end else
                                x_count <= x_count - 1;
                        
                        RIGHT: // Starting in top left corner, scanning right then down.
                            if(x_count == search_x1) begin
                                x_count <= search_x0;
                                y_count <= y_count + 1;
                            end else
                                x_count <= x_count + 1;
                    endcase
                end
                FINISHED: begin
                    done    <= 1'b1;
                    found   <= !outside_of_search_frame;
                    found_x <= x_count;
                    found_y <= y_count;
                end
            endcase
        end
    end
endmodule

module edge_search_testbench();

    // Connections to the searcher.
    logic [9:0] search_x0, search_y0, search_x1, search_y1;
    logic start, clk, reset;
    logic [1:0] search_direction;
    logic [9:0] found_x, found_y;
    logic done;
    logic found;
    
    // Connections to pixel cache.
    logic [9:0] x, y;   // Location of pixel to read.
    logic request;      // Request a new pixel.
    logic pixel;        // Pixel (true or false), only valid when ready is asserted.
    logic ready;

    edge_search dut(.*);

    // Set up the clock.
    parameter CLOCK_PERIOD=100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    integer i, j, dir;
    initial begin
        start<=0;
        search_x0 <= '0;
        search_y0 <= '0;
        search_x1 <= 9;
        search_y1 <= 9;

        // Searches that complete
        for(dir=0;dir<4;dir++) begin
            search_direction <= dir;
            reset<=1; @(posedge clk);
            reset<=0; @(posedge clk);
            start<=1; @(posedge clk);
            start<=0; @(posedge clk);
            
            for(i=0;i<11;i++) begin
                for(j=0;j<11;j++) begin
                    ready<=1; @(posedge clk);
                    ready<=0; @(posedge clk);
                    if(i==5 && j==5) pixel <= 1;
                    else             pixel<=0;
                    @(posedge clk);
                end
            end
        end

        // Searches that don't complete
        for(dir=0;dir<4;dir++) begin
            search_direction <= dir;
            reset<=1; @(posedge clk);
            reset<=0; @(posedge clk);
            start<=1; @(posedge clk);
            start<=0; @(posedge clk);
            
            for(i=0;i<11;i++) begin
                for(j=0;j<11;j++) begin
                    ready<=1; @(posedge clk);
                    ready<=0; @(posedge clk);
                    pixel<=0; @(posedge clk);
                end
            end
        end
        
        $stop;
    end
endmodule 