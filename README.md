# Tool to flash info onto the LTA
Edit the flashInfo.json file to edit info sent to the TLA Flash

Plugin micro-USB Cable to LTA and computer. On LTA, have switches 1 and 4 in the ON position. All other Switches should be in the off position.

Adding to the flash is simple.
```console
foo@bar:~$ sudo python3.7 ltaLoadFlash <lta number> 
``` 

For example, if you wanted to load the info for lta called SKIPPER 14
```console
foo@bar:~$ sudo python3.7 ltaLoadFlash 14
```

By default, the program assumes you are plugged into '/dev/ttyUSB0'. If using a different port (i.e. port 2)
```console
foo@bar:~$ sudo python3.7 ltaLoadFlash 14 /dev/ttyUSB1
```
