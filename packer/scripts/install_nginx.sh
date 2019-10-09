#!/bin/bash
apt update -y
#Cтавим tzdata так как требует дополнительного вмешательства

apt update
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
apt-get install tzdata
dpkg-reconfigure --frontend noninteractive tzdata

apt install nginx -y

mv /tmp/otus.conf /etc/nginx/conf.d/

mkdir /etc/nginx/ssl

mv /tmp/privkey.pem /etc/nginx/ssl

mv /tmp/fullchain.pem /etc/nginx/ssl

sudo systemctl enable nginx
