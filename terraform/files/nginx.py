import os
var = os.argv[1]

f = open('upstream.conf', 'w')

f.write("upstream puma_application {")
for x in range(os.argv[1]):
  f.write("server puma-" + x + ":8080 max_fails=1 fail_timeout=10s;")
f.write("}\n")
