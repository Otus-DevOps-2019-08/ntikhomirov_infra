import sys

var = {{ count | default('1') }}

pref = {{ env | default('test') }}

f = open('/tmp/upstream.conf', 'w')

f.write("upstream puma_application {\n")

for x in range(var):
  f.write("server puma-" + pref + "-" + str(x) + ":8080 max_fails=1 fail_timeout=10s;\n")
f.write("}\n")
