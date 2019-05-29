onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Interface
add wave -noupdate /pixel_cache_testbench/clk
add wave -noupdate -radix unsigned /pixel_cache_testbench/x
add wave -noupdate -radix unsigned /pixel_cache_testbench/y
add wave -noupdate /pixel_cache_testbench/ready
add wave -noupdate /pixel_cache_testbench/pixel
add wave -noupdate -divider Internals
add wave -noupdate -radix unsigned /pixel_cache_testbench/rdaddress
add wave -noupdate /pixel_cache_testbench/cache/rdata
add wave -noupdate /pixel_cache_testbench/cache/ps
add wave -noupdate -radix unsigned /pixel_cache_testbench/cache/requested_address
add wave -noupdate -radix unsigned /pixel_cache_testbench/cache/ready_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10265 ps} 0}
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
WaveRestoreZoom {0 ps} {9293 ps}
