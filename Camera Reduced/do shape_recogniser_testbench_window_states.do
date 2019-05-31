onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/shape_recogniser_testbench/KEY[0]}
add wave -noupdate -divider Controller
add wave -noupdate /shape_recogniser_testbench/dut/start_algorithm
add wave -noupdate /shape_recogniser_testbench/dut/ps
add wave -noupdate /shape_recogniser_testbench/dut/current_direction
add wave -noupdate /shape_recogniser_testbench/dut/start_search
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_wire
add wave -noupdate /shape_recogniser_testbench/dut/edge_found
add wave -noupdate /shape_recogniser_testbench/dut/box/ps
add wave -noupdate -divider pixel_cache
add wave -noupdate /shape_recogniser_testbench/dut/cache/pixel
add wave -noupdate /shape_recogniser_testbench/dut/cache/ready
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/y
add wave -noupdate -divider {New Divider}
add wave -noupdate /shape_recogniser_testbench/dut/reset_search
add wave -noupdate /shape_recogniser_testbench/dut/box/ps
add wave -noupdate /shape_recogniser_testbench/dut/edge_done
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/search_x0
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/search_y0
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/search_x1
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/search_y1
add wave -noupdate /shape_recogniser_testbench/dut/box/start
add wave -noupdate /shape_recogniser_testbench/dut/box/clk
add wave -noupdate /shape_recogniser_testbench/dut/box/reset
add wave -noupdate /shape_recogniser_testbench/dut/box/search_direction
add wave -noupdate /shape_recogniser_testbench/dut/box/done
add wave -noupdate /shape_recogniser_testbench/dut/box/found
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/box/y
add wave -noupdate /shape_recogniser_testbench/dut/box/pixel
add wave -noupdate /shape_recogniser_testbench/dut/box/ready
add wave -noupdate -divider Edge_search
add wave -noupdate /shape_recogniser_testbench/dut/box/search_x0
add wave -noupdate /shape_recogniser_testbench/dut/box/search_y0
add wave -noupdate /shape_recogniser_testbench/dut/box/search_x1
add wave -noupdate /shape_recogniser_testbench/dut/box/search_y1
add wave -noupdate /shape_recogniser_testbench/dut/box/start
add wave -noupdate /shape_recogniser_testbench/dut/box/clk
add wave -noupdate /shape_recogniser_testbench/dut/box/reset
add wave -noupdate /shape_recogniser_testbench/dut/box/search_direction
add wave -noupdate /shape_recogniser_testbench/dut/box/done
add wave -noupdate /shape_recogniser_testbench/dut/box/found
add wave -noupdate /shape_recogniser_testbench/dut/box/x
add wave -noupdate /shape_recogniser_testbench/dut/box/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5143079 ps} 0} {{Cursor 2} {8157176 ps} 0} {{Cursor 3} {31934593 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {8148056 ps} {8158787 ps}
