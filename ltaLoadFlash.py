#!/usr/bin/env python
import ltaFlash
import json
import sys

# load info from json file and user
if len(sys.argv) < 3:
    print('The scirpt should be called as:')
    print('\tpython {0} <json file> <LTA #>'.format(sys.argv[0]))
    print('i.e.\n\tpython {0} flashInfo_v22.json 42'.format(sys.argv[0]))
    sys.exit()

json_file_name = sys.argv[1]
id_num = sys.argv[2]

# LTA number
id_num = int(id_num)
id_num = "{0:#06x}".format(id_num)


# read data from json
with open(json_file_name, 'r') as json_file:
  data = json_file.read()
  info = json.loads(data)

# open connection to LTA
lta = ltaFlash.ltaFlash()
lta.checkPassword()

#for i in range(67108608, 67108644):
#	lta.eraseAddr(i)

lta.flashInfo()

lta.write('0x03FFFF05', 1, info["Firmware"]["date"]["day"])
"""
print('Writing new info to lta flash')

lta.write('0x03FFFF00', 1, info["Firmware"]["version"]["minor"])
lta.write('0x03FFFF01', 1, info["Firmware"]["version"]["major"])

lta.write('0x03FFFF04', 1, info["Firmware"]["date"]["month"])
lta.write('0x03FFFF05', 1, info["Firmware"]["date"]["day"])
lta.write('0x03FFFF06', 2, info["Firmware"]["date"]["year"])

lta.write('0x03FFFF08', 8, '0x'+info["Firmware"]["hash"][:8])
lta.write('0x03FFFF0C', 8, '0x'+info["Firmware"]["hash"][8:])


lta.write('0x03FFFF10', 1, info["Software"]["version"]["minor"])
lta.write('0x03FFFF11', 1, info["Software"]["version"]["major"])


lta.write('0x03FFFF14', 1, info["Software"]["date"]["month"])
lta.write('0x03FFFF15', 1, info["Software"]["date"]["day"])
lta.write('0x03FFFF16', 2, info["Software"]["date"]["year"])

lta.write('0x03FFFF18', 8, '0x'+info["Software"]["hash"][:8])
lta.write('0x03FFFF1C', 8, '0x'+info["Software"]["hash"][8:])

lta.write('0x03FFFF20', 8, info["Unique ID"]+id_num[2:])

ip = info["Board IP"]
ip_dec = 0
for word in ip.split("."):
    ip_dec <<= 8
    ip_dec += int(word)
lta.write('0x03FFFF24', 8, ip_dec)
"""
lta.flashInfo()

lta.close()
