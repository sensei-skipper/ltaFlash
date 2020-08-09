# Tool to flash info onto the LTA
Edit the flashInfo.json file to edit info sent to the TLA Flash

Plugin micro-USB Cable to LTA and computer. On LTA, have switches 1 and 4 in the ON position. All other Switches should be in the off position.

Adding to the flash is simple.
```console
foo@bar:~$ sudo python ltaLoadFlash.py <json file> <lta number> 
``` 

For example, if you wanted to load the info for lta called SKIPPER 14
```console
foo@bar:~$ sudo python ltaLoadFlash.py flashInfo_v22.json 14
```

NOTE: If info was already flashed to lta, you must erase the it before putting new info on
```console
foo@bar:~$ sudo python cleaerInfo.py
```
