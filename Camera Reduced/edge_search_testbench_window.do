onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Controls
add wave -noupdate /edge_search_testbench/start
add wave -noupdate /edge_search_testbench/clk
add wave -noupdate /edge_search_testbench/reset
add wave -noupdate -radix unsigned -childformat {{{/edge_search_testbench/search_direction[1]} -radix unsigned} {{/edge_search_testbench/search_direction[0]} -radix unsigned}} -subitemconfig {{/edge_search_testbench/search_direction[1]} {-height 15 -radix unsigned} {/edge_search_testbench/search_direction[0]} {-height 15 -radix unsigned}} /edge_search_testbench/search_direction
add wave -noupdate -divider Status
add wave -noupdate -radix unsigned /edge_search_testbench/found_x
add wave -noupdate -radix unsigned /edge_search_testbench/found_y
add wave -noupdate /edge_search_testbench/done
add wave -noupdate /edge_search_testbench/found
add wave -noupdate -divider {Pixel IF}
add wave -noupdate /edge_search_testbench/request
add wave -noupdate /edge_search_testbench/pixel
add wave -noupdate /edge_search_testbench/ready
add wave -noupdate -radix unsigned /edge_search_testbench/x
add wave -noupdate -radix unsigned /edge_search_testbench/y
add wave -noupdate -divider Internals
add wave -noupdate /edge_search_testbench/dut/ps
add wave -noupdate /edge_search_testbench/dut/ns
add wave -noupdate -radix unsigned /edge_search_testbench/dut/x_count
add wave -noupdate -radix unsigned /edge_search_testbench/dut/y_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {550 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {42473 ps}
