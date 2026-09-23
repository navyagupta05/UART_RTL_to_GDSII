###############################################################################
# Created by write_sdc
# Tue Sep 22 19:41:05 2026
###############################################################################
current_design uart_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {baud_sel[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {baud_sel[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {baud_sel[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_in[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rdy_clr}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {wr_en}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {busy}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[2]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[3]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[4]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[5]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[6]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {data_out[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rdy}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {busy}]
set_load -pin_load 0.0334 [get_ports {rdy}]
set_load -pin_load 0.0334 [get_ports {data_out[7]}]
set_load -pin_load 0.0334 [get_ports {data_out[6]}]
set_load -pin_load 0.0334 [get_ports {data_out[5]}]
set_load -pin_load 0.0334 [get_ports {data_out[4]}]
set_load -pin_load 0.0334 [get_ports {data_out[3]}]
set_load -pin_load 0.0334 [get_ports {data_out[2]}]
set_load -pin_load 0.0334 [get_ports {data_out[1]}]
set_load -pin_load 0.0334 [get_ports {data_out[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rdy_clr}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {wr_en}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {baud_sel[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {baud_sel[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {baud_sel[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[7]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[6]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[5]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[4]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[3]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {data_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 70.0000 [current_design]
