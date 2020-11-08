# Loops over all connected LTAs and boots them from flash. Should be similar to a power-cycle.
# vivado_lab -mode batch -notrace -source boot_flash.tcl
# If you only want to boot one LTA, supply the FPGA DNA (serial number) as a command-line argument:
# vivado_lab -mode batch -notrace -source boot_flash.tcl -tclargs 2A12111E7221002B
# If you just want to print all the FPGA DNAs without rebooting anything you can supply a garbage value that does not match any FPGA, e.g.
# vivado_lab -mode batch -notrace -source boot_flash.tcl -tclargs BLAH

if { $argc > 0 } {
    set dna [lindex $argv 0]
    puts "searching for FPGA DNA $dna"
}

open_hw
connect_hw_server

puts "connected FPGA programmers: [get_hw_targets]"

foreach {target} [get_hw_targets] {
    current_hw_target $target
    open_hw_target
    current_hw_device [lindex [get_hw_devices] 0]

    if { $argc > 0 } {
        #refresh_hw_device -quiet [current_hw_device]
        set this_dna [get_property REGISTER.EFUSE.FUSE_DNA [current_hw_device]]
        puts "this FPGA DNA is $this_dna"
        if {[string compare $dna $this_dna]==0} {
            puts "found the requested FPGA! booting this LTA from flash"
        } else {
            close_hw_target
            continue
        }
    }

    boot_hw_device [current_hw_device]
    close_hw_target
    exit
}
puts "did not find the requested FPGA"
exit
