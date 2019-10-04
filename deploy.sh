#!/bin/bash

#Устанавливаем nginx (не гоже приложению болтаться на 9292 порту)
sudo bash -s <<EOF
apt install nginx -y
EOF


#Ужасный способа не придумал как добавить конфиг для nginx
sudo bash -s <<EOF
echo 'server {' > /etc/nginx/conf.d/otus.conf
echo 'listen 10.164.0.2:80;' >> /etc/nginx/conf.d/otus.conf
echo 'server_name otus.nt33.ru;' >> /etc/nginx/conf.d/otus.conf
echo 'location / {'  >> /etc/nginx/conf.d/otus.conf
echo '    proxy_pass http://127.0.0.1:9292/;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header Host \$host;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header X-Real-IP  \$remote_addr;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' >> /etc/nginx/conf.d/otus.conf
echo '    allow all;' >> /etc/nginx/conf.d/otus.conf
echo '  }' >> /etc/nginx/conf.d/otus.conf
echo '}' >> /etc/nginx/conf.d/otus.conf

echo '[Unit]' > /etc/systemd/system/otus.service
echo 'Description=puma' >> /etc/systemd/system/otus.service

echo '' >> /etc/systemd/system/otus.service
echo '[Service]' >> /etc/systemd/system/otus.service
echo 'ExecStart=/usr/local/bin/puma -d' >> /etc/systemd/system/otus.service
echo 'KillMode=process' >> /etc/systemd/system/otus.service
echo 'Restart=on-failure' >> /etc/systemd/system/otus.service
echo 'Type=notify' >> /etc/systemd/system/otus.service
echo '' >> /etc/systemd/system/otus.service
echo '[Install]' >> /etc/systemd/system/otus.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/otus.service
echo 'Alias=sshd.service' >> /etc/systemd/system/otus.service
EOF

#Деплой приложения
mkdir -p ~/app
cd ~/app
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install


#А что puma не может иметь своего собственого юнита?
sudo systemctl daemon reload

sudo systemctl start otus
sudo systemctl enable otus

sudo systemctl start nginx
sudo systemctl enable nginx
