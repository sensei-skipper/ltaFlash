# Tool to flash info onto the LTA v2
The LTA has a flash memory that is divided into two regions (a firmware image and a "info" page) and two USB ports (mini-USB serial port and micro-USB JTAG port).

The firmware image combines the FPGA firmware and the software that runs inside the FPGA (this is distinct from the "LTA daemon" that runs on the PC and communicates to the LTA).

The LTA's IP address is saved in the info page, along with the LTA number and firmware/software versions.

The current and past SENSEI firmware images, along with the appropriate info page data, are saved in the `fw` directory.

## Using serial port
Edit the flashInfo.json file to edit info sent to the LTA Flash

Plugin micro-USB Cable to LTA and computer. On LTA, have switches 1 and 4 in the ON position. All other Switches should be in the off position.

Adding to the flash is simple.
```console
foo@bar:~$ sudo python ltaLoadFlash.py <json file> <lta number> 
``` 

For example, if you wanted to load the info for lta called SKIPPER 14
```console
foo@bar:~$ sudo python ltaLoadFlash.py flashInfo_v22.json 14
```

NOTE: If info was already flashed to lta, you must erase it before putting new info on
```console
foo@bar:~$ sudo python clearInfo.py
```

## Using USB-JTAG
