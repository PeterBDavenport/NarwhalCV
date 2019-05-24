onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /video_still_testbench/CLOCK_PERIOD
add wave -noupdate /video_still_testbench/clk
add wave -noupdate /video_still_testbench/reset
add wave -noupdate /video_still_testbench/start
add wave -noupdate /video_still_testbench/iVGA_VS
add wave -noupdate /video_still_testbench/iVGA_HS
add wave -noupdate /video_still_testbench/write
add wave -noupdate -radix decimal /video_still_testbench/x
add wave -noupdate -radix decimal /video_still_testbench/y
add wave -noupdate /video_still_testbench/i
add wave -noupdate /video_still_testbench/j
add wave -noupdate /video_still_testbench/dut/ps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1017508 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {989603 ps} {990672 ps}
