import sys
var = int(sys.argv[1])
f = open('/tmp/upstream.conf', 'w')

f.write("upstream puma_application {\n")
for x in range(var):
  f.write("server puma-" + str(x) + ":8080 max_fails=1 fail_timeout=10s;\n")
f.write("}\n")
