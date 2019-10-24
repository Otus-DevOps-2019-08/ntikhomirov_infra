#!/usr/bin/env python
import yaml, json

with open('./inventory.yml') as f:
    print(json.dumps(yaml.load(f)))
