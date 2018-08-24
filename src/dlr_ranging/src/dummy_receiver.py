"""
import socket
import sys
import time
import thread
import signal


run=True
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('127.0.0.1', 6001)


def handler(clientsock,addr):
    print('handle()')
    while True:
            fp=open('Log_Ranging.txt','rb')
            
            #for i in range(1000):
            #        byte = fp.read(1000)
            #byte = fp.read(1)
            
            print('loop1')
            while byte != "":
                    clientsock.send(byte)
                    byte = fp.read(1)
                    time.sleep(0.00001);
                    print('Send %d' % byte)
            print('loop2')


try:
    print >>sys.stderr, 'starting up on %s port %s' % server_address
    sock.bind(server_address)

    sock.listen(1)
    conn, addr = sock.accept()




    while run:
            (clientsocket, address) = sock.accept()
            thread.start_new_thread(handler, (clientsocket, addr))
except KeyboardInterrupt:
    print('Interrupt')
finally:
    sock.shutdown(socket.SHUT_WR)
    sock.close()
"""


import socket               # Import socket module
import time

s = socket.socket()         # Create a socket object

try:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    host = 'localhost' # Get local machine name
    port = 52001                 # Reserve a port for your service.
    s.bind((host, port))        # Bind to the port
    s.listen(5)                 # Now wait for client connection.
    while True:
        try:
            print('waiting for connection')
            c, addr = s.accept()     # Establish connection with client.
            f = open('Log_Ranging.txt','rb')
            print 'Got connection from', addr
            while c:
                l = f.read(10)
                while (l):
                    c.send(l)
                    time.sleep(0.1)
                    l = f.read(10)
                print('rewinding file')
                f.seek(0)
            c.shutdown(socket.SHUT_WR)
        except socket.error:
            pass
        f.close()
        print "Client disconnected"
            
except KeyboardInterrupt:
    s.shutdown(socket.SHUT_WR)
finally:
    s.close()                # Close the connection
