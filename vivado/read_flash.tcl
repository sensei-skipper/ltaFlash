# Read the connected LTA's flash, writes contents to readback.mcs in the current directory. After this is run, the LTA is rebooted from flash.
# vivado_lab -mode batch -source read_flash.tcl

open_hw
connect_hw_server

current_hw_target [get_hw_devices xc7a200t_0]
open_hw_target
current_hw_device [get_hw_devices]

create_hw_cfgmem -hw_device [current_hw_device] -mem_dev [lindex [get_cfgmem_parts {mt25ql512-spi-x1_x2_x4}] 0]

set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]

create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]
program_hw_devices [current_hw_device]

readback_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [get_hw_devices xc7a200t_0 ]] -file readback.mcs -format MCS -force -all

boot_hw_device [current_hw_device]

close_hw_target
exit
