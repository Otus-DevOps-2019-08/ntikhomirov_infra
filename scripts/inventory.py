#!/usr/bin/env python3.6
import json

gce = True

#Подключаем модули для использования API GCE
try:
    from googleapiclient import discovery
    from oauth2client.client import GoogleCredentials
except Exception as e:
    import yaml
    gce = False

inventory = {}
inventory['db'] = {}
inventory['app'] = {}
inventory['proxy'] = {}

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
                          inventory['db'][instance['name']] = 'null'
                      elif str(i) == 'app':
                          inventory['app'][instance['name']] = 'null'
                      elif str(i) == 'proxy':
                          inventory['proxy'][instance['name']] = 'null'

       request = service.instances().list_next(previous_request=request, previous_response=response)
    print(inventory)

else:
    with open('./inventory.yml') as f:
        print(json.dumps(yaml.load(f)))
