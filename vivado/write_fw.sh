#source this script from a directory that contains memory.mcs and memory.prm, e.g.:
#  source ../../vivado/write_fw.sh
#this will write the FW on all connected LTAs

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
    $vivadoname -mode batch -notrace -source $scriptdir/write_flash.tcl
else
    echo "no vivado command in environment; do you need to source settings64.sh?"
fi
