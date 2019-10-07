#!/bin/bash
VM_NAME='reddit-app-test'

gcloud compute instances delete ${VM_NAME} --zone=europe-west4-a
