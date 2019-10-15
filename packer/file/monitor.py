#!/usr/bin/env python3
import cgi
import os

def ping(hostname):
   response = os.system("ping -c 1 " + hostname)
   if response == 0:
      print( hostname,'is up!')
   else:
      print( hostname,'is down!')

ping("127.0.0.1")

