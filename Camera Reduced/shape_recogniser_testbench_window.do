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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7421239 ps} 0} {{Cursor 2} {2944397 ps} 0} {{Cursor 3} {31934593 ps} 0}
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
WaveRestoreZoom {0 ps} {15753216 ps}
