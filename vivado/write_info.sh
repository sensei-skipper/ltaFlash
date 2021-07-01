#source this script from a directory that contains flashInfo.json
#need 1 or 2 arguments for LTA number and (optionally) IP, e.g.:
#  source ../../vivado/write_info.sh 12
#  source ../../vivado/write_info.sh 12 192.168.133.3
#this will write the flash info on all connected (USB-JTAG plugged in, and powered) LTAs, so you should only use this script with a single LTA connected at a time
#if you have multiple LTAs connected you can write to individual ones using the FPGA DNA, see write_flash.tcl

#get the path to ltaFlash/vivado
scriptdir=$(dirname "$BASH_SOURCE")

#find the correct vivado command
if command -v vivado_lab &> /dev/null; then
    vivadoname="vivado_lab"
else if command -v vivado &> /dev/null; then
    vivadoname="vivado"
else
    vivadoname=""
fi
fi

if [ "$vivadoname" ]; then
    #delete the existing memory_info.mcs, so we don't accidentally write a stale one
    rm -f memory_info.mcs memory_info.prm
    ln -s $scriptdir/memory_info.prm
    $scriptdir/writeMCS.py flashInfo.json $*
    $vivadoname -mode batch -notrace -source $scriptdir/write_flash.tcl -tclargs memory_info
else
    echo "no vivado command in environment; do you need to source settings64.sh?"
fi
