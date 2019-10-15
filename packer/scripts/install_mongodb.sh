#!/bin/bash
#Добавляем ключ репозитория
wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -

#Добавляем репозиторий
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list

#Устанавливаем Mongo
apt update

apt install -y mongodb-org

sudo systemctl enable mongod
