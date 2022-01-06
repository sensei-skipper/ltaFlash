v1: 2019-03-19
* this was SENSEI standard firmware
* "legacy" sequencer (.txt files not .xml, sequencer runs in firmware)
* multi-LTA support

v20: 2019-07-17
* this was SENSEI standard firmware
* first "smart" sequencer firmware (.xml files, sequencer runs on its own Microblaze processor)

v21: 2020-05-25
* software compiled with -O3, max sequencer speed is increased
* multi-LTA support, but a bug causes the slave's sequencer to randomly enter a bad state and stop taking images

v22: 2020-07-10
* this was SENSEI standard firmware
* working multi-LTA firmware, fixes the bug in v21
* clock bug creates (randomly on each boot, on some channels) period-3 noise on CDS output, workarounds:
  * (only works for master) make all sequencer loop periods =0 mod 3 
  * reboot master until it looks good, then reboot each slave until it looks good

v23: 2021-05-02
* not widely used - only in TAU cross-3 and SiDet supercube-1
* changes to clock distribution: slave sequencer+ADC+CDS clocks all come from master
* fixes the clock bug in v22, but new clock bug creates period-20 noise on CDS output, workaround:
  * make all sequencer loop periods =0 mod 20

v24: 2021-06-21
* this was SENSEI standard firmware
* fixes the clock bug in v23: no known issues or needed workarounds for single or multi-LTA
* common 15 MHz clock for sequencer+ADC+CDS
* sequencer microblaze runs faster (100 MHz up from 75)

v25: 2022-01-06
* this was SENSEI standard firmware
* improved multi-LTA reliability - seems to work OK with VME adapters
* fixes the VSUB-is-low-after-erase bug
* user-configurable soak times for erase and e-purge
* limited ramp rate on LDOs - reduces current spike from raising VSUB
* slight sequencer speedup (branch predictor cache)
