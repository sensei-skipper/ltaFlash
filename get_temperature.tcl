# Prints the connected LTA's FPGA temperature in a loop.
# vivado_lab -mode batch -source get_temperature.tcl
open_hw
connect_hw_server

open_hw_target

current_hw_device [get_hw_devices xc7a200t_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a200t_0] 0]

while {1} {
refresh_hw_sysmon  [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]
#report_property  [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]
#get_property -verbose TEMPERATURE [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]
puts [get_property TEMPERATURE [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]]
after 100
}
exit
