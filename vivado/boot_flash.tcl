# Loops over all connected LTAs and reboots them from flash. Should be similar to a power-cycle.
# vivado_lab -mode batch -source boot_flash.tcl

open_hw
connect_hw_server

foreach {target} [get_hw_targets] {
    puts "booting $target"
    current_hw_target $target
    open_hw_target
    current_hw_device [get_hw_devices]

    boot_hw_device [current_hw_device]

    close_hw_target
}
exit
