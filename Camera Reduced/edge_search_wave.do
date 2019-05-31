onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /edge_search_testbench/search_x0
add wave -noupdate /edge_search_testbench/search_y0
add wave -noupdate /edge_search_testbench/search_x1
add wave -noupdate /edge_search_testbench/search_y1
add wave -noupdate /edge_search_testbench/start
add wave -noupdate /edge_search_testbench/clk
add wave -noupdate /edge_search_testbench/reset
add wave -noupdate /edge_search_testbench/search_direction
add wave -noupdate /edge_search_testbench/found_x
add wave -noupdate /edge_search_testbench/found_y
add wave -noupdate /edge_search_testbench/done
add wave -noupdate /edge_search_testbench/found
add wave -noupdate /edge_search_testbench/x
add wave -noupdate /edge_search_testbench/y
add wave -noupdate /edge_search_testbench/dut/x_count
add wave -noupdate /edge_search_testbench/dut/y_count
add wave -noupdate /edge_search_testbench/request
add wave -noupdate /edge_search_testbench/pixel
add wave -noupdate /edge_search_testbench/ready
add wave -noupdate /edge_search_testbench/i
add wave -noupdate /edge_search_testbench/j
add wave -noupdate /edge_search_testbench/dut/ps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9621150 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9620563 ps} {9621737 ps}
