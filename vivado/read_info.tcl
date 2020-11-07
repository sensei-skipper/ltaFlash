# Read the connected LTA's flash info, writes contents to readback_info.mcs in the current directory. After this is run, the LTA is rebooted from flash.
# vivado_lab -mode batch -notrace -source read_info.tcl
# If multiple LTAs are connected, by default we read the first one (whatever that means).
# If you supply an FPGA DNA as an argument, we search for that LTA and read that one:
# vivado_lab -mode batch -notrace -source read_info.tcl -tclargs 2A12111E7221002B

if { $argc == 1 } {
    set dna [lindex $argv 0]
    puts "searching for FPGA DNA $dna"
}

open_hw
connect_hw_server

foreach {target} [get_hw_targets] {
    current_hw_target $target
    open_hw_target
    current_hw_device [lindex [get_hw_devices] 0]

    if { $argc == 1 } {
        set this_dna [get_property REGISTER.EFUSE.FUSE_DNA [current_hw_device]]
        if {[string compare $dna $this_dna]!=0} {
            close_hw_target
            continue
        }
        puts "found requested FPGA, will read this one"
    }

    create_hw_cfgmem -hw_device [current_hw_device] -mem_dev [lindex [get_cfgmem_parts {mt25ql512-spi-x1_x2_x4}] 0]

    set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]

    create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]
    program_hw_devices [current_hw_device]

    readback_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [current_hw_device]] -file readback_info.mcs -format MCS -force -offset 0x03FFFF00 -datacount 0xFF

    boot_hw_device [current_hw_device]

    close_hw_target
    exit
}
puts "did not find the requested FPGA"
exit
