#!/usr/bin/env python3
import cgi
import os
import socket
from contextlib import closing
var=COUNT_ID

def ping(hostname):
   response = os.system("ping -c 1 " + hostname)
   if response == 0:
      print( hostname,'is up!')
   else:
      print( hostname,'is down!')

def check_socket(host, port):
   response = os.system("ping -c 1 " + host)
   if response == 0:
           with closing(socket.socket(socket.AF_INET, socket.SOCK_STREAM)) as sock:
                 if sock.connect_ex((host, port)) == 0:
                         print (host, ":" , port, "Port is open")
                 else:
                         print (host, ":", port, "Port is not open")


ping("nginx")
check_socket("nginx",80)

ping("mongo")
check_socket("mongo",27017)

for x in range(var):
  ping("puma-" + str(x))
  check_socket("puma-" + str(x),8080)
