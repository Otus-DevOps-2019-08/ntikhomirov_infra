#!/bin/bash
sudo apt update

sudo bash -s <<EOF
apt update
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
apt-get install tzdata
dpkg-reconfigure --frontend noninteractive tzdata
EOF

#Инсталяция ruby и bundler
sudo apt install -y ruby-full ruby-bundler build-essential
#Проверяем версии
ruby -v
bundler -v
sudo gem install bundle