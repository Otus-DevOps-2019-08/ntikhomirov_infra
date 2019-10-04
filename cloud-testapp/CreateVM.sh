#!/bin/bash
#Название машины
VM_NAME='reddit-app-test'
#Внутренний IP
PRIVATE_IP='10.164.0.2'
#Внешний IP(зарезервированный)
IP='34.66.250.139'

gcloud beta compute --project=indigo-almanac-254221 \
  instances create ${VM_NAME} \
  --zone=europe-west4-a \
  --machine-type=f1-micro \
  --subnet=default \
  --private-network-ip=${PRIVATE_IP} \
  --address=34.90.19.140 \
  --image=ubuntu-minimal-1604-xenial-v20190918 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=${VM_NAME} \
  --reservation-affinity=any
  --tags=http-server
