#!/bin/bash

apt install git -y

#Деплой приложения
mkdir -p ~/app
cd ~/app
git clone -b monolith https://github.com/express42/reddit.git
cd ~/app/reddit

bundle install

mv /tmp/otus.service /etc/systemd/system/

systemctl enable otus.service
