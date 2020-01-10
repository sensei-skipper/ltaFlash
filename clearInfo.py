import ltaFlash
import sys

port = sys.argv[2] if len(sys.argv) >2 else '/dev/ttyUSB0'
# open connection to LTA
lta = ltaFlash.ltaFlash(port)
lta.checkPassword()

lta.flashInfo()

#Erase data
for i in range(67108608,67108654):
	lta.eraseAddr(i)


lta.flashInfo()
lta.close()