onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /area_calculator_testbench/clk
add wave -noupdate /area_calculator_testbench/start
add wave -noupdate /area_calculator_testbench/done
add wave -noupdate -radix unsigned /area_calculator_testbench/area
add wave -noupdate -divider internals
add wave -noupdate -radix unsigned /area_calculator_testbench/x
add wave -noupdate -radix unsigned /area_calculator_testbench/y
add wave -noupdate /area_calculator_testbench/pixel
add wave -noupdate /area_calculator_testbench/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16409 ps} 0}
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
WaveRestoreZoom {0 ps} {32603 ps}
