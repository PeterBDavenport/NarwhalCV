onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /edge_search_testbench/clk
add wave -noupdate /edge_search_testbench/reset
add wave -noupdate -divider pixel_cache
add wave -noupdate /edge_search_testbench/cache/pixel
add wave -noupdate /edge_search_testbench/cache/ready
add wave -noupdate -radix unsigned /edge_search_testbench/cache/x
add wave -noupdate -radix unsigned /edge_search_testbench/cache/y
add wave -noupdate -divider edge_search
add wave -noupdate /edge_search_testbench/dut/start
add wave -noupdate /edge_search_testbench/dut/done
add wave -noupdate /edge_search_testbench/dut/found
add wave -noupdate /edge_search_testbench/dut/ps
add wave -noupdate /edge_search_testbench/dut/direction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {118644 ps} 0} {{Cursor 2} {889 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ps} {2176 ps}
