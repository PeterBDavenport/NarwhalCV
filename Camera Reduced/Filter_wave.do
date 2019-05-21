onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Constants /Filter_testbench/WIDTH
add wave -noupdate -group Constants /Filter_testbench/HEIGHT
add wave -noupdate -group Constants /Filter_testbench/NUM_FRAMES
add wave -noupdate -group Constants /Filter_testbench/CLOCK_PERIOD
add wave -noupdate -group Constants /Filter_testbench/H_SYNC_CYC
add wave -noupdate -group Constants /Filter_testbench/H_SYNC_BACK
add wave -noupdate -group Constants /Filter_testbench/H_SYNC_ACT
add wave -noupdate -group Constants /Filter_testbench/H_SYNC_FRONT
add wave -noupdate -group Constants /Filter_testbench/H_SYNC_TOTAL
add wave -noupdate -group Constants /Filter_testbench/V_SYNC_CYC
add wave -noupdate -group Constants /Filter_testbench/V_SYNC_BACK
add wave -noupdate -group Constants /Filter_testbench/V_SYNC_ACT
add wave -noupdate -group Constants /Filter_testbench/V_SYNC_FRONT
add wave -noupdate -group Constants /Filter_testbench/V_SYNC_TOTAL
add wave -noupdate -group Constants /Filter_testbench/H_BLANK
add wave -noupdate -group Constants /Filter_testbench/V_BLANK
add wave -noupdate -radix unsigned /Filter_testbench/inputR
add wave -noupdate -radix unsigned /Filter_testbench/inputG
add wave -noupdate -radix unsigned /Filter_testbench/inputB
add wave -noupdate -radix unsigned /Filter_testbench/outputR
add wave -noupdate -radix unsigned /Filter_testbench/outputG
add wave -noupdate -radix unsigned /Filter_testbench/outputB
add wave -noupdate /Filter_testbench/reset_n
add wave -noupdate /Filter_testbench/VGA_CLK
add wave -noupdate -radix unsigned /Filter_testbench/H_Cont
add wave -noupdate -radix unsigned /Filter_testbench/V_Cont
add wave -noupdate /Filter_testbench/iVGA_BLANK_N
add wave -noupdate /Filter_testbench/iVGA_HS
add wave -noupdate /Filter_testbench/iVGA_VS
add wave -noupdate -radix unsigned /Filter_testbench/iVGA_B
add wave -noupdate -radix unsigned /Filter_testbench/iVGA_G
add wave -noupdate -radix unsigned /Filter_testbench/iVGA_R
add wave -noupdate -radix unsigned /Filter_testbench/oVGA_B
add wave -noupdate -radix unsigned /Filter_testbench/oVGA_G
add wave -noupdate -radix unsigned /Filter_testbench/oVGA_R
add wave -noupdate /Filter_testbench/oVGA_HS
add wave -noupdate /Filter_testbench/oVGA_VS
add wave -noupdate /Filter_testbench/oVGA_SYNC_N
add wave -noupdate /Filter_testbench/oVGA_BLANK_N
add wave -noupdate -radix unsigned /Filter_testbench/out_x
add wave -noupdate -radix unsigned /Filter_testbench/out_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2056312 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 5000
configure wave -gridperiod 10000
configure wave -griddelta 4
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2056186 ps} {2057728 ps}
