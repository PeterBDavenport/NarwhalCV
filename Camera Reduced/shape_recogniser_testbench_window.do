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
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/x_count
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/y_count
add wave -noupdate -divider image_memory
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/data
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/wraddress
add wave -noupdate /shape_recogniser_testbench/dut/image/wren
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/rdaddress
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/q
add wave -noupdate -divider outputs
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_B
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_G
add wave -noupdate -radix unsigned /shape_recogniser_testbench/oVGA_R
add wave -noupdate /shape_recogniser_testbench/oVGA_HS
add wave -noupdate /shape_recogniser_testbench/oVGA_VS
add wave -noupdate /shape_recogniser_testbench/oVGA_SYNC_N
add wave -noupdate /shape_recogniser_testbench/oVGA_BLANK_N
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {767662 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 65
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
WaveRestoreZoom {0 ps} {4321088 ps}
