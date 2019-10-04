#!/bin/bash

#Устанавливаем nginx (не гоже приложению болтаться на 9292 порту)
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

sudo apt install nginx -y

#Ужасный способа не придумал как добавить конфиг для nginx
sudo echo 'server {' > /etc/nginx/conf.d/otus.confg
sudo echo 'listen 10.164.0.2:80;' >> /etc/nginx/conf.d/otus.confg
sudo echo 'server_name otus.nt33.ru' >> /etc/nginx/conf.d/otus.confg
sudo echo 'location / {'  >> /etc/nginx/conf.d/otus.confg
sudo echo '    proxy_pass http://127.0.0.1:9292/;' >> /etc/nginx/conf.d/otus.confg
sudo echo '    proxy_set_header Host $host;' >> /etc/nginx/conf.d/otus.confg
sudo echo '    proxy_set_header X-Real-IP  $remote_addr;' >> /etc/nginx/conf.d/otus.confg
sudo echo '    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> /etc/nginx/conf.d/otus.confg
sudo echo '    allow all;' >> /etc/nginx/conf.d/otus.confg
sudo echo '  }' >> /etc/nginx/conf.d/otus.confg
sudo echo '}' >> /etc/nginx/conf.d/otus.confg


#Деплой приложения
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install


#А что puma не может иметь своего собственого юнита?

sudo echo '[Unit]' > /etc/systemd/system/otus.service
sudo echo 'Description=puma' >> /etc/systemd/system/otus.service

sudo echo '' >> /etc/systemd/system/otus.service
sudo echo '[Service]' >> /etc/systemd/system/otus.service
sudo echo 'ExecStart=/home/tihomirovnv/reddit/puma -p' >> /etc/systemd/system/otus.service
sudo echo 'KillMode=process' >> /etc/systemd/system/otus.service
sudo echo 'Restart=on-failure' >> /etc/systemd/system/otus.service
sudo echo 'Type=notify' >> /etc/systemd/system/otus.service
sudo echo '' >> /etc/systemd/system/otus.service
sudo echo '[Install]' >> /etc/systemd/system/otus.service
sudo echo 'WantedBy=multi-user.target' >> /etc/systemd/system/otus.service
sudo echo 'Alias=sshd.service' >> /etc/systemd/system/otus.service

sudo systemctl daemon reload
sydo systemctl start otus
sydo systemctl enable otus

sydo systemctl start nginx
sydo systemctl enable nginx
