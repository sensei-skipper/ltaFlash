#!/usr/bin/env python
import json
import sys
import struct

# load info from json file and user
if len(sys.argv) < 3:
    print('The script should be called as:')
    print('\tpython {0} <json file> <LTA #>'.format(sys.argv[0]))
    print('i.e.\n\tpython {0} flashInfo_v22.json 42'.format(sys.argv[0]))
    sys.exit()

mcsFilename = "vivado/memory_info.mcs"

json_file_name = sys.argv[1]
id_num = sys.argv[2]

# LTA number
id_num = int(id_num)
id_num = "{0:#06x}".format(id_num)

# read data from json
with open(json_file_name, 'r') as json_file:
  data = json_file.read()
  info = json.loads(data)

#MCS file format taken from https://en.wikipedia.org/wiki/Intel_HEX and checked by comparing to the output of ltaDaemon/scripts/vivado/read_info.tcl

def extendedLinearAddress(offset):
    d = struct.pack('>H', offset) #offset is big-endian
    return (0x04, d, 0x0)

def endOfFile():
    return (0x01, [], 0x0)

def recordToString(record):
    recordType = record[0]
    dataList = record[1]
    offset = record[2]
    dataLen = len(record[1])
    dataString = ""
    checksum = dataLen + (offset % 256) + (offset / 256) + recordType
    for dataByte in dataList:
        dataString += ("%02X" % ord(dataByte))
        checksum += ord(dataByte)
    checksum %= 256
    if checksum != 0:
        checksum = 256-checksum
    return ":{0:02X}{1:04X}{2:02X}{3:s}{4:02X}\n".format(dataLen, offset, recordType, dataString, checksum)


with open(mcsFilename, 'w') as mcsFile:
    mcsFile.write(recordToString(extendedLinearAddress(0x03FF)))

    currentAddr = 0x00
    lastAddr = 0xFEFF
    while lastAddr>currentAddr:
        nextAddr = min(lastAddr, currentAddr+0xF)+1
        d = ['\xFF' for i in range(currentAddr, nextAddr)]
        mcsFile.write(recordToString((0x00, d, currentAddr)))
        currentAddr = nextAddr

    d = struct.pack('BBHBBHII', info["Firmware"]["version"]["minor"], info["Firmware"]["version"]["major"], 0xFFFF, info["Firmware"]["date"]["month"], info["Firmware"]["date"]["day"], info["Firmware"]["date"]["year"], int(info["Firmware"]["hash"][:8],16), int(info["Firmware"]["hash"][8:],16))
    mcsFile.write(recordToString((0x00, d, 0xFF00)))

    d = struct.pack('BBHBBHII', info["Software"]["version"]["minor"], info["Software"]["version"]["major"], 0xFFFF, info["Software"]["date"]["month"], info["Software"]["date"]["day"], info["Software"]["date"]["year"], int(info["Software"]["hash"][:8],16), int(info["Software"]["hash"][8:],16))
    mcsFile.write(recordToString((0x00, d, 0xFF10)))

    ip_dec = 0
    for word in info["Board IP"].split("."):
        ip_dec <<= 8
        ip_dec += int(word)
    d = struct.pack('IIQ', int(info["Unique ID"]+id_num[2:],16), ip_dec, 0xFFFFFFFFFFFFFFFF)
    mcsFile.write(recordToString((0x00, d, 0xFF20)))

    currentAddr = 0xFF30
    lastAddr = 0xFFFF
    while lastAddr>currentAddr:
        nextAddr = min(lastAddr, currentAddr+0xF)+1
        d = ['\xFF' for i in range(currentAddr, nextAddr)]
        mcsFile.write(recordToString((0x00, d, currentAddr)))
        currentAddr = nextAddr

    mcsFile.write(recordToString(endOfFile()))

    print "wrote flash info to", mcsFilename
