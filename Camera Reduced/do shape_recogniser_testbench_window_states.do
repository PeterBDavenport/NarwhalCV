onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider image_memory
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/rdaddress
add wave -noupdate -radix unsigned /shape_recogniser_testbench/dut/image/q
add wave -noupdate -divider results
add wave -noupdate /shape_recogniser_testbench/dut/right_x
add wave -noupdate /shape_recogniser_testbench/dut/left_x
add wave -noupdate /shape_recogniser_testbench/dut/top_y
add wave -noupdate /shape_recogniser_testbench/dut/bottom_y
add wave -noupdate /shape_recogniser_testbench/dut/area
add wave -noupdate -divider User
add wave -noupdate {/shape_recogniser_testbench/dut/KEY[1]}
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4744250 ps} 0} {{Cursor 2} {779332 ps} 0} {{Cursor 3} {31934593 ps} 0}
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
