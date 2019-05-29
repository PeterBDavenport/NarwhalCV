onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bounding_box_finder_testbench/clock
add wave -noupdate /bounding_box_finder_testbench/data
add wave -noupdate /bounding_box_finder_testbench/rdaddress
add wave -noupdate /bounding_box_finder_testbench/wraddress
add wave -noupdate /bounding_box_finder_testbench/wren
add wave -noupdate /bounding_box_finder_testbench/q
add wave -noupdate /bounding_box_finder_testbench/x
add wave -noupdate /bounding_box_finder_testbench/y
add wave -noupdate /bounding_box_finder_testbench/request
add wave -noupdate /bounding_box_finder_testbench/clk
add wave -noupdate /bounding_box_finder_testbench/reset
add wave -noupdate /bounding_box_finder_testbench/pixel
add wave -noupdate /bounding_box_finder_testbench/ready
add wave -noupdate /bounding_box_finder_testbench/rdata
add wave -noupdate /bounding_box_finder_testbench/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8917 ps} 0}
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
WaveRestoreZoom {8543 ps} {10025 ps}
