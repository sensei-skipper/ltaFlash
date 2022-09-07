#!/bin/bash

#run this script from a directory that contains flashInfo.json
#need 1, 2, or 3 arguments for LTA number and (optionally) IP and FPGA DNA, e.g.:
#  ../../vivado/write_info.sh 12 (write ID 12 and IP from JSON, to all connected LTAs)
#  ../../vivado/write_info.sh 12 192.168.133.3 (write ID 12 and IP 192.168.133.3, to all connected LTAs)
#  ../../vivado/write_info.sh 12 192.168.133.3 2A12111E7221002B (write ID 12 and IP 192.168.133.3, to LTA with FPGA DNA 2A12111E7221002B)
#the first two forms will write the flash info on all connected (USB-JTAG plugged in, and powered) LTAs, so should only be used with a single LTA connected at a time

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
if [[ "$#" -eq 0 ]]
then
    echo "must give LTA ID"
    exit
fi

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
