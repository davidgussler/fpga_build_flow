set build_dir ./build
set top_module    $::env(TOP_MODULE)


open_hw_manager


# Connect to the Cable on localhost:3121
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210183B04156A]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210183B04156A]
open_hw_target

# Program and Refresh the Device
set device [lindex [get_hw_devices] 0]
current_hw_device $device
refresh_hw_device -update_hw_probes false $device
set_property PROGRAM.FILE "$build_dir/${top_module}.bit" $device
#set_property PROBES.FILE "$build_dir/${top_module}.ltx" $device

program_hw_devices $device
refresh_hw_device $device
