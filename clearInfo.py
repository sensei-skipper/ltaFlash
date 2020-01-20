import ltaFlash
import sys

# open connection to LTA
lta = ltaFlash.ltaFlash()
lta.checkPassword()

lta.flashInfo()

#Erase data
for i in range(67108608,67108654):
	lta.eraseAddr(i)


lta.flashInfo()
lta.close()