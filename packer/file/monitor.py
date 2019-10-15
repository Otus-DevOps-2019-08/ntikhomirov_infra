#!/usr/bin/env python3
import cgi
import os
import socket
from contextlib import closing

def ping(hostname):
   response = os.system("ping -c 1 " + hostname)
   if response == 0:
      print( hostname,'is up!')
   else:
      print( hostname,'is down!')

def check_socket(host, port):
    with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as sock:
        if sock.connect_ex((host, port)) == 0:
            print (host, ":" , port, "Port is open")
        else:
            print (host, ":", port, "Port is not open")

ping("127.0.0.1")
check_socket("127.0.0.1",80)
check_socket("127.0.0.1",443)

ping("10.164.0.38")
check_socket("10.164.0.38",27017)
