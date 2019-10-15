#!/bin/bash

apt install nginx fcgiwrap -y

mv /tmp/otus.conf /etc/nginx/conf.d/

mkdir /etc/nginx/ssl

mkdir -p /opt/www/monitor/cgi-bin

mv /tmp/privkey.pem /etc/nginx/ssl

mv /tmp/fullchain.pem /etc/nginx/ssl


sudo systemctl enable nginx
