#!/usr/bin/env python
import ltaFlash
import sys

# open connection to LTA
lta = ltaFlash.ltaFlash()
lta.checkPassword()

lta.flashInfo()

#Erase data
lta.eraseAddr(0x3FFFF00)

lta.flashInfo()
lta.close()
