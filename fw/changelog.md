v1
v21
v22: 2020-07-10
* working multi-LTA firmware
* software compiled with -O3
* clock bug creates (randomly on each boot, on some channels) period-3 noise on CDS output, workarounds:
 * (only works for master) make all sequencer loop periods =0 mod 3 
 * reboot master until it looks good, then reboot each slave until it looks good

v23
* not widely used - only in TAU cross-3 and SiDet supercube-1
* changes to clock distribution: slave sequencer+ADC+CDS clocks all come from master
* fixes the clock bug in v22, but new clock bug creates period-20 noise on CDS output, workaround:
 * make all sequencer loop periods =0 mod 20

v24
