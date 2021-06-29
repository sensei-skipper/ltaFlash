# Prints the connected LTA's FPGA temperature in a loop.
# vivado_lab -mode batch -notrace -source get_temperature.tcl
open_hw
connect_hw_server

current_hw_target [lindex [get_hw_targets] 0]
open_hw_target

current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -quiet [current_hw_device]

while {1} {
    refresh_hw_sysmon -properties {TEMPERATURE} [lindex [get_hw_sysmons] 0]
    #report_property  [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]
    #get_property -verbose TEMPERATURE [get_hw_sysmons localhost:3121/xilinx_tcf/Digilent/*/xc7a200t_0/SYSMON]
    puts [get_property TEMPERATURE [lindex [get_hw_sysmons] 0]]
    after 1000
}
exit
