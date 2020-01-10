import serial
import time

class ltaFlash:
	def __init__(self, port='/dev/ttyUSB0'):
		""" Connect to lta Flash via serial port on computer"""
		self.com = serial.Serial(port, 9600, timeout=3)
	
	def close(self):
		""" Close the Port connection """
		self.com.close()

	def send(self, cmd):
		""" Send Command to flash and return output """
		cmd = cmd + '\r'
		cmd = cmd.encode()

		self.com.write(cmd)
		time.sleep(1)
		out = self.com.read(self.com.inWaiting())
		
		return out.decode()


	def checkPassword(self):
		""" Check if flash asks for password and sign in """
		out = self.send('')
		if 'password:' in out:
			out += self.send('lta-root')
			print(out)
		else:
			print('Did not ask for password')


	def flashInfo(self):
		""" Print Flash info """
		out = self.send('flash info')
		print(out)


	def readAddr(self, addr, n=1):
		""" Read value at certain address for <n> bytes """
		""" returns the hexadecimal value """
		if isinstance(addr, int):
			# convert to hexidecimal
			addr = f"{addr:#0{10}x}"

		cmd = "read {0} {1}".format(addr, n)
		out = self.send(cmd)
		
		# iterate through bytes
		b = []
		for i in range(n):
			out = out[out.index("\n")+1:]

			xs = out.index(": 0x") + 4
			xe = out.index("\t\r")

			b.append(out[xs:xe])

		value = '0x'
		for i in b[::-1]:
			value += i

		print(addr + ": " +  value + " -> " + str(int(value,16)))
		return value


	def write(self, addr, n, value):
		""" write <value> of size <n> to <addr> """
		if isinstance(addr, int):
			addr = f"{addr:#0{10}x}" #hexadecimal form

		if n==1:
			n='byte'
		elif n==2:
			n='word'
		elif n==8:
			n='qword'
		elif n not in ['byte', 'word', 'qword']:
			print("ERROR: Invalid input of number of data type <n>")
			sys.exit()

		cmd = "write {0} {1} {2}".format(n, addr, value)
		print(cmd)
		self.send(cmd)


	def eraseAddr(self, addr):
		""" Erase 4kb adress """
		if isinstance(addr, int):
			addr = f"{addr:#0{10}x}"

		self.send("erase "+addr)

