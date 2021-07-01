#!/bin/bash

#run this script from a directory that contains memory.mcs (or memory.mcs.gz) and memory.prm, e.g.:
#  cd fw/v24
#  ../../vivado/write_fw.sh
#this will write the FW on all connected LTAs

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

#if we have no .mcs file but we have the .mcs.gz
#-k so we keep the compressed file (keeps git happy)
if [ ! -e "memory.mcs" ] && [ -e "memory.mcs.gz" ]; then
    gunzip -k memory.mcs.gz
fi

$vivadoname -mode batch -notrace -source "$scriptdir"/write_flash.tcl
