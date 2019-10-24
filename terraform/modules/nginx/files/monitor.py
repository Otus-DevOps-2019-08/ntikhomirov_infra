#!/usr/bin/env python3
import cgi
import os
import socket
from contextlib import closing
var=COUNT_ID
pref="PREF"
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


ping("nginx-" + pref)
check_socket("nginx-" + pref,80)

ping("mongo-" + pref)
check_socket("mongo-" + pref,27017)

for x in range(var):
  ping("puma-" + pref + "-" + str(x))
  check_socket("puma-" + pref + "-" + str(x),8080)
