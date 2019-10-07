
#Создаю правило на фаерволе
gcloud compute firewall-rules create puma-server\
  --allow=TCP:9292\
  --target-tags=puma-server
