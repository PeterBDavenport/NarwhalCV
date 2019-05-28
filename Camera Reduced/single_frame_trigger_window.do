onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /single_frame_trigger_testbench/clk
add wave -noupdate /single_frame_trigger_testbench/reset
add wave -noupdate /single_frame_trigger_testbench/trigger
add wave -noupdate /single_frame_trigger_testbench/VS
add wave -noupdate /single_frame_trigger_testbench/HS
add wave -noupdate /single_frame_trigger_testbench/capture
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {274 ps} 0}
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
WaveRestoreZoom {3237 ps} {4725 ps}
