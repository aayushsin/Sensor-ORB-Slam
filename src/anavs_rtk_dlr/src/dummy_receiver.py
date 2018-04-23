import socket
import sys
import time
import thread

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 6001)
print >>sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)

sock.listen(1)

conn, addr = sock.accept()

def handler(clientsock,addr):
	while True:
		fp=open('dummy_data.txt')
		
		for i in range(1000):
			byte = fp.read(1000)
		
		byte = fp.read(1)
		
		while byte != "":
			clientsock.send(byte)
			byte = fp.read(1)
			time.sleep(0.00001);

while True:
	(clientsocket, address) = sock.accept()
	thread.start_new_thread(handler, (clientsocket, addr))