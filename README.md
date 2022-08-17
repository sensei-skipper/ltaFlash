# Tool to flash info and firmware onto the LTA v2
The LTA has a flash memory that is divided into two regions (a firmware image and a "info" page) and two USB ports (mini-USB serial port and micro-USB JTAG port).

The firmware image combines the FPGA firmware and the software that runs inside the FPGA (this is distinct from the "LTA daemon" that runs on the PC and communicates to the LTA).
The LTA's IP address is saved in the info page, along with the LTA number and firmware/software versions; the LTA prints the info when booting.
The `fw` directory contains firmware images and the corresponding info page data.

Serial port communication does not require additional software, just the scripts in this repo.
JTAG communication requires Xilinx Vivado and cable drivers installed.

You can update the flash info using either the serial or JTAG port.
The firmware image can only be updated with JTAG.

*If you update the firmware, you should also update the info to match. This keeps it easy to see what firmware any LTA is running.*

## Using serial port to update flash info
Edit the flashInfo.json file to edit info sent to the LTA flash (the IP is the only thing you might typically change).

Plug in mini-USB cable. This must be the only LTA with this cable connected.
On LTA, have switches 1 and 4 in the ON position.
All other switches should be in the off position.
Power on.

Before writing to the flash, you must erase it:
```console
foo@bar:~$ ./clearInfo.py
```

Adding to the flash is simple.
```console
foo@bar:~$ ./ltaLoadFlash.py <json file> <lta number> 
``` 

For example, if you wanted to load the info for the LTA called SKIPPER 14
```console
foo@bar:~$ ./ltaLoadFlash.py fw/v24/flashInfo.json 14
```

Remember to return the switches to normal position (switch 1 ON, switch 4 OFF).

## Using USB-JTAG to update firmware image or flash info
Plug in micro-USB cable. If multiple LTAs are plugged in, they will all be programmed - this is generally fine for the firmware, but not for the flash info.
Switch position does not matter.
(This means that you can keep the cable connected and update the flash remotely.)

Setup Vivado (the path will depend on how your PC is set up) and move into the directory for the firmware you are using (or want to use):
```console
foo@bar:~$ source ~/Soft/Xilinx/Vivado_Lab/2018.3/settings64.sh
foo@bar:~$ cd fw/v24
```

### Write the flash info
You can use whatever IP address is in the `flashInfo,json`, or specify it on the command line.

Both examples, for LTA 14:
```console
foo@bar:~$ ../../vivado/write_info.sh 14
```
```console
foo@bar:~$ ../../vivado/write_info.sh 14 192.168.133.3
```

### Write the firmware image
```console
foo@bar:~$ ../../vivado/write_fw.sh
```

### Installing Vivado
Lab Edition is recommended unless you plan to develop or compile firmware, but the full edition is fine.
The version doesn't matter (scripts are tested on 2018.3).
You can download it from the Xilinx website: https://www.xilinx.com/support/download.html

After installing the software, you need to install the cable drivers separately:
```console
foo@bar:~$ cd ~/Soft/Xilinx/Vivado_Lab/2018.3/data/xicom/cable_drivers/lin64/install_script/install_drivers/
foo@bar:~$ sudo ./install_drivers
```

