gcloud beta compute --project=indigo-almanac-254221 \
  instances create reddit-app --zone=europe-west4-a \
  --machine-type=f1-micro --subnet=default \
  --private-network-ip=10.164.0.5 --no-address \
  --image=ubuntu-minimal-1604-xenial-v20190918 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=reddit-app \
  --reservation-affinity=any
