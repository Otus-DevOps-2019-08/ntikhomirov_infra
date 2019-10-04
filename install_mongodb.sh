#!/bin/bash
#Добавляем ключ репозитория
gpg --keyserver subkeys.pgp.net --recv D68FA50FEA312927
gpg --export --armor D68FA50FEA312927 | sudo apt-key add -

#Добавляем репозиторий
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

#Устанавливаем Mongo
sudo apt update
sudo apt install -y mongodb-org

sydo systemctl start mongod
sydo systemctl enable mongod
