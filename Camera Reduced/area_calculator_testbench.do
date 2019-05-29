# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./area_calculator.sv"
vlog "./image_memory.v"
vlog "./pixel_cache.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work area_calculator_testbench -Lf altera_mf_ver

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do area_calculator_testbench_window.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
