#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Illegal number of paramaters"
	echo "./ltaFlash.sh <LTA #>"
	exit 1
fi

start=$SECONDS

# Generate memory_info.mcs file
./writeMCS.py ../flashInfo_v22.json ${1}

# Write firmware and software to LTA
vivado_lab -mode batch -source write_flash.tcl

# write flash info to LTA
vivado_lab -mode batch -source write_flash_info.tcl

# Delete memory_info.mcs file
rm memory_info.mcs

duration=$(( SECONDS - start ))
echo "This took ${duration} seconds to run"

