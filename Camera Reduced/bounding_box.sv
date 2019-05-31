
/*
 * The algorithm controller will begin by finding the top edge,  right
 * edge, bottom edge, than left. From that it will load a small register
 * with the coordinates of the box. This will be used to draw the box.
 * ...
 *
 */

enum {S_IDLE, S_TOP,    S_TOP_WAIT, S_RIGHT, S_RIGHT_WAIT, 
            S_BOTTOM, S_BOTTOM_WAIT, S_LEFT, S_LEFT_WAIT, S_DRAW_BOX, S_AREA, S_AREA_WAIT ...} ps, ns;

//location coordinates of the box given by edge_search
logic [9:0] top_y,       right_x,
            bottom_y,    left_x;

logic start_alogrithm;
logic edge_done;
logic area_done;
logic current_direction;
logic start_search, start_area;

//search and area wires connect module to pixel cache through mux
//selected by case logic in ff block
logic x_search_wire, y_search_wire;
logic x_area_wire, y_area_wire;
logic x_wire, y_wire;
edge_search  box(.search_x0(WIDTH/4), .search_y0(HEIGHT/4), .search_x1(WIDTH*3/4), .search_y1(HEIGHT*3/4), 
                     .start(start_search), .clk, .reset, .search_direction(current_direction),
                     .done(edge_done), .found, .x(x_search_wire), .y(y_search_wire), .pixel, .ready);

area_calculator  shape(.x0, .y0, .x1, .y1, .start, .clk, .done(area_done), .area, 
                                               .x(x_wire), .y(y_wire), .pixel, .ready);

pixel_cache  cache(.clk, .reset, .pixel, .ready, .x(x_area_wire), .y(y_area_wire), .rdaddress, .rdata);

always_comb begin
    case (ps) 
    S_IDLE          : begin 
                        if(start_algorithm) ns = S_TOP;
                        else                ns = S_IDLE;
                      end
    S_TOP           : ns = S_TOP_WAIT; 
    S_TOP_WAIT      : begin 
                        if(edge_done)       ns = S_RIGHT;
                        else                ns = S_TOP_WAIT;
                      end
    S_RIGHT         : ns = S_RIGHT_WAIT;
    S_RIGHT_WAIT    : begin
                        if(edge_done)       ns = S_BOTTOM;
                        else                ns = S_RIGHT_WAIT;
                      end
    S_BOTTOM        : ns = S_BOTTOM_WAIT;
    S_BOTTOM_WAIT   : begin
                        if(edge_done)       ns = S_RIGHT;
                        else                ns = S_TOP_WAIT;
                      end
    S_LEFT          : ns = S_LEFT_WAIT;
    S_LEFT_WAIT     : begin
                        if(edge_done)       ns = S_DRAW_BOX;
                        else                ns = S_LEFT_WAIT;
                      end
    S_AREA          : ns = S_AREA_WAIT;
    S_AREA_WAIT     : begin
                        if(area_done)       ns = //////////////////////////////
                        else                ns = S_AREA_WAIT;
                      end
    endcase
end

always_ff @(posedge clk) begin
    if(reset)
        ps <= S_IDLE;
    else begin
        ps <= ns;
        case (ps) 
        S_TOP           : begin
                            start_search <= 1;          //to find top, start at the top left 
                            current_direction <= 2'b01; //scan right than step down
                          end 
        S_TOP_WAIT      : begin 
                            start_search <= 0;
                            y_wire <= y_search_wire;
                            top_y <= y_wire;
                          end
        S_RIGHT         : begin
                            start_search <= 1;          //to find right, start at the top right 
                            current_direction <= 2'b10; //scan down than step left
                          end 
        S_RIGHT_WAIT    : begin 
                            start_search <= 0;
                            x_wire <= x_search_wire;
                            right_x <= x_wire;
                          end
        S_BOTTOM        : begin
                            start_search <= 1;          // Start at the bottom left 
                            current_direction <= 2'b00; // scan to the right than step up
                          end 
        S_BOTTOM_WAIT   : begin 
                            start_search <= 0;
                            y_wire <= y_search_wire;
                            bottom_y <= y_wire;
                          end
        S_LEFT          : begin
                            start_search <= 1;          // Start at the top right
                            current_direction <= 2'b11; // scan down than step right
                          end 
        S_LEFT_WAIT     : begin 
                            start_search <= 0;
                            x_wire <= x_search_wire;
                            left_x <= x_wire;
                          end
        S_AREA          : begin
                            start_area <= 1;
                            x0 <= left_x;
                            y0 <= top_y;
                            x1 <= right_x;
                            y1 <= right_y;
                          end
        S_AREA_WAIT     : begin
                            start_area <= 0;
                            x_wire <= x_area_wire;
                            left_x <= x_wire;
                            y_wire <= x_area_wire;
                            left_x <= y_wire;
                          end
        endcase
    end
end

                     
