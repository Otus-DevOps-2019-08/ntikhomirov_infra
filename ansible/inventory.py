#!/usr/bin/env python
import json

flag = True
try:
    import psycopg2
except Exception as e:
    import yaml
    flag = False

if flag :
    conn = psycopg2.connect(dbname='inventory', user='inventory', host='localhost')

    cursor = conn.cursor()

    cursor.execute('select vpxv_hosts.name name_node, vms.name name_vm,vms.mem_size_mb mem,vms.num_vcpu cpu, round(vms.aggr_commited_storage_space/(1024*1024*1024),2) space, vms.power_state power, vms.description description from vpxv_vms as vms left join vpxv_hosts on (vms.hostid = vpxv_hosts.hostid) order by name_node,name_vm')

    for row in cursor:
	       tr= tr + "<tr><td>" +row[0] + "</td><td>" +row[1] + "</td><td>" + str(row[2]) + "</td><td>" + str(row[3]) + "</td><td>" + str(row[4]) + "</td><td>" +row[5] + "</td><td>" +row[6] + "</td></tr>"

    cursor.close()
    conn.close()
else :
    with open('./inventory.yml') as f:
        print(json.dumps(yaml.load(f)))
