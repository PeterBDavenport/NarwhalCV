onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /shape_recogniser_testbench/dut/VGA_CLK
add wave -noupdate {/shape_recogniser_testbench/dut/KEY[0]}
add wave -noupdate {/shape_recogniser_testbench/dut/KEY[1]}
add wave -noupdate /shape_recogniser_testbench/dut/pixel_darker_than_cutoff
add wave -noupdate /shape_recogniser_testbench/dut/edge_done
add wave -noupdate /shape_recogniser_testbench/dut/current_direction
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_search_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_search_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_wire
add wave -noupdate -divider dims
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/bottom_y
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/top_y
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/right_x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/left_x
add wave -noupdate -divider div
add wave -noupdate /shape_recogniser_testbench/dut/algoritm_running
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/area
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/saved_area
add wave -noupdate /shape_recogniser_testbench/dut/start_area
add wave -noupdate /shape_recogniser_testbench/dut/ps
add wave -noupdate -divider Area
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/x0
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/y0
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/x1
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/y1
add wave -noupdate /shape_recogniser_testbench/dut/shape/start
add wave -noupdate /shape_recogniser_testbench/dut/shape/clk
add wave -noupdate /shape_recogniser_testbench/dut/shape/done
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/area
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/shape/y
add wave -noupdate /shape_recogniser_testbench/dut/shape/pixel
add wave -noupdate /shape_recogniser_testbench/dut/shape/ready
add wave -noupdate -divider wires
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_search_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_search_wire
add wave -noupdate /shape_recogniser_testbench/dut/pixel
add wave -noupdate /shape_recogniser_testbench/dut/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19958428 ps} 0} {{Cursor 2} {5654950 ps} 0} {{Cursor 3} {31934593 ps} 0} {{Cursor 4} {3018825 ps} 0} {{Cursor 5} {7419955 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 150
configure wave -valuecolwidth 87
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 50
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {20957003 ps}
