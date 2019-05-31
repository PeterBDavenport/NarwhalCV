# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./shape_recogniser.sv"
vlog "./pixel_counter.sv"
vlog "./image_memory.v"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work shape_recogniser_testbench -Lf altera_mf_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do shape_recogniser_testbench_window_states.do
#do shape_recogniser_testbench_window.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
