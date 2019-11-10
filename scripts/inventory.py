#!/usr/bin/env python3.6
import os
import sys
import argparse

try:
    import json
except ImportError:
    import simplejson as json

gce = True

evn = 'prod'

count = 0

#Подключаем модули для использования API GCE
try:
    from googleapiclient import discovery
    from oauth2client.client import GoogleCredentials
except Exception as e:
    import yaml
    gce = False

class Inventory(object):
    gce = ""
    def __init__(self):
        self.inventory = {}
        self.read_cli_args()
        if self.args.list:
           self.inventory = self.dynamic_inventory()
        elif self.args.host:
           self.inventory = self.empty_inventory()
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory));

    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}


    def dynamic_inventory(self):
       inventory = {
           'app': {
               'hosts': [],
               'vars': {}
           },
           'db': {
               'hosts': [],
               'vars': {}
           },
           'proxy': {
               'hosts': [],
               'vars': {}
           },
           '_meta': {
           }
       }
       if gce:
          credentials = GoogleCredentials.get_application_default()
          service = discovery.build('compute', 'v1', credentials=credentials)

          # Возможно надо убрать в конфиг
          project = 'indigo-almanac-254221'

          # Возможно надо убрать в конфиг
          zone = 'europe-west4-a'

          request = service.instances().list(project=project, zone=zone)

          while request is not None:
             response = request.execute()
             #Производим выборку по tags из инстансов которые созданы в gcloud
             for instance in response['items']:
               if 'items' in instance['tags']:
                  t = instance['tags']['items']
                  for i in t:
                      if str(i)== 'db' :
                          inventory['db']['hosts'].append(instance['name'])
                          for j in instance['networkInterfaces'] :
                            inventory['app']['vars']['db_url'] = str(j['networkIP'])

                      elif str(i) == 'app':
                          inventory['app']['hosts'].append(instance['name'])
                          count = count + 1
                      elif str(i) == 'proxy':
                          inventory['proxy']['hosts'].append(instance['name'])
                      elif str(i) == 'prod' or str(i) == 'test':
                          inventory['app']['vars']['env'] = str(i)
                          inventory['proxy']['vars']['env'] = str(i)
                          inventory['db']['vars']['env'] = str(i)
             request = service.instances().list_next(previous_request=request, previous_response=response)
          inventory['proxy']['vars']['ount'] = count
          return inventory
       else:
          with open('./inventory.yml') as f:
            print(json.dumps(yaml.load(f)))

    def read_cli_args(self):
          parser = argparse.ArgumentParser()
          parser.add_argument('--list', action = 'store_true')
          parser.add_argument('--host', action = 'store')
          self.args = parser.parse_args()



Inventory()
