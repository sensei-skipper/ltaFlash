# Expects "memory.mcs" and "memory.prm" files in the current directory. Writes those files to the connected LTA's flash. Loops over all connected LTAs.
# vivado_lab -mode batch -notrace -source write_flash.tcl
# To specify a different input filename (e.g. memory_info.mcs, memory_info.prm):
# vivado_lab -mode batch -notrace -source write_flash.tcl -tclargs memory_info
# If you also specify an FPGA DNA, only that LTA will be programmed:
# vivado_lab -mode batch -notrace -source write_flash.tcl -tclargs memory_info 2A12111E7221002B

if { $argc != 0 } {
    set infile [lindex $argv 0]
} else {
    set infile "memory"
}
puts "using input files $infile.mcs, $infile.prm"

if { $argc == 2 } {
    set dna [lindex $argv 1]
    puts "searching for FPGA DNA $dna"
}

open_hw
connect_hw_server

foreach {target} [get_hw_targets] {
    current_hw_target $target
    open_hw_target -quiet
    current_hw_device [lindex [get_hw_devices] 0]

    if { $argc == 2 } {
        set this_dna [get_property REGISTER.EFUSE.FUSE_DNA [current_hw_device]]
        if {[string compare $dna $this_dna]!=0} {
            close_hw_target
            continue
        } else {
            puts "found requested FPGA, will program this one"
        }
    }

    create_hw_cfgmem -hw_device [current_hw_device] -mem_dev [lindex [get_cfgmem_parts {mt25ql512-spi-x1_x2_x4}] 0]

    set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.FILES [list "$infile.mcs" ] [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.PRM_FILE {"$infile.prm"} [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]
    set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]

    create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]
    program_hw_devices [current_hw_device]

    program_hw_cfgmem -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [current_hw_device]]

    boot_hw_device [current_hw_device]

    close_hw_target -quiet

    if { $argc == 2 } {
        exit
    }
}
if { $argc == 2 } {
    puts "did not find the requested FPGA"
}
exit
