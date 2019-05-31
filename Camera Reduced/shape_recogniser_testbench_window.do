onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /shape_recogniser_testbench/iVGA_B
add wave -noupdate -radix unsigned /shape_recogniser_testbench/iVGA_G
add wave -noupdate -radix unsigned /shape_recogniser_testbench/iVGA_R
add wave -noupdate /shape_recogniser_testbench/iVGA_HS
add wave -noupdate /shape_recogniser_testbench/iVGA_VS
add wave -noupdate /shape_recogniser_testbench/iVGA_SYNC_N
add wave -noupdate /shape_recogniser_testbench/iVGA_BLANK_N
add wave -noupdate -divider location
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y
add wave -noupdate -divider image_memory
add wave -noupdate -radix binary /shape_recogniser_testbench/dut/image/data
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/wraddress
add wave -noupdate /shape_recogniser_testbench/dut/image/wren
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/rdaddress
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/q
add wave -noupdate -divider filterd
add wave -noupdate /shape_recogniser_testbench/dut/pixel_buffer
add wave -noupdate /shape_recogniser_testbench/dut/pixel_darker_than_cutoff
add wave -noupdate -divider outputs
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_B
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_G
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_R
add wave -noupdate /shape_recogniser_testbench/oVGA_HS
add wave -noupdate /shape_recogniser_testbench/oVGA_VS
add wave -noupdate /shape_recogniser_testbench/oVGA_SYNC_N
add wave -noupdate /shape_recogniser_testbench/oVGA_BLANK_N
add wave -noupdate -divider User
add wave -noupdate {/shape_recogniser_testbench/KEY[0]}
add wave -noupdate {/shape_recogniser_testbench/KEY[2]}
add wave -noupdate -divider Controller
add wave -noupdate /shape_recogniser_testbench/dut/start_algorithm
add wave -noupdate /shape_recogniser_testbench/dut/ps
add wave -noupdate /shape_recogniser_testbench/dut/current_direction
add wave -noupdate /shape_recogniser_testbench/dut/start_search
add wave -noupdate /shape_recogniser_testbench/dut/start_area
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_search_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_search_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_area_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_wire
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_wire
add wave -noupdate /shape_recogniser_testbench/dut/area
add wave -noupdate -divider edge_search
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
add wave -noupdate /shape_recogniser_testbench/dut/box/ps
add wave -noupdate -divider pixel_cache
add wave -noupdate /shape_recogniser_testbench/dut/cache/clk
add wave -noupdate /shape_recogniser_testbench/dut/cache/reset
add wave -noupdate /shape_recogniser_testbench/dut/cache/pixel
add wave -noupdate /shape_recogniser_testbench/dut/cache/ready
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/x
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/y
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/rdaddress
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/cache/rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4744250 ps} 0} {{Cursor 2} {1010207 ps} 0} {{Cursor 3} {31934593 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ps} {8566163 ps}
