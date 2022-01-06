#!/bin/bash

#run this script from a directory that contains flashInfo.json
#need 1, 2, or 3 arguments for LTA number and (optionally) IP and FPGA DNA, e.g.:
#  ../../vivado/write_info.sh 12
#  ../../vivado/write_info.sh 12 192.168.133.3
#  ../../vivado/write_info.sh 12 192.168.133.3 2A12111E7221002B
# the first 2 forms will write the flash info on all connected (USB-JTAG plugged in, and powered) LTAs
# if you have multiple LTAs connected you must use the last form to specify which FPGA DNA you are configuring

#get the path to ltaFlash/vivado
scriptdir=$(dirname "$0")

#find the correct vivado command
if command -v vivado_lab &> /dev/null; then
    vivadoname="vivado_lab"
elif command -v vivado &> /dev/null; then
    vivadoname="vivado"
else
    echo "no vivado command in environment; do you need to source settings64.sh?"
    exit
fi

#delete the existing memory_info.mcs, so we don't accidentally write a stale one
rm -f memory_info.mcs memory_info.prm
ln -s "$scriptdir"/memory_info.prm .
if [[ "$#" -eq 1 ]]
then
    "$scriptdir"/writeMCS.py flashInfo.json "$1"
else
    "$scriptdir"/writeMCS.py flashInfo.json "$1" "$2"
fi

if [[ "$#" -eq 3 ]]
then
    $vivadoname -mode batch -notrace -source "$scriptdir"/write_flash.tcl -tclargs memory_info "$3"
else
    $vivadoname -mode batch -notrace -source "$scriptdir"/write_flash.tcl -tclargs memory_info
fi
