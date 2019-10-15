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

ping("nginx")
check_socket("nginx",80)
check_socket("nginx",443)

ping("mongo")
check_socket("mongo",27017)

ping("puma1")
check_socket("puma1",8080)
ping("puma2")
check_socket("puma2",8080)
