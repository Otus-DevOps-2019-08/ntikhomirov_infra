#!/bin/bash

apt install nginx fcgiwrap -y

mv /tmp/otus.conf /etc/nginx/conf.d/

mkdir /etc/nginx/ssl

mkdir -p /opt/www/monitor/cgi-bin

mv /tmp/privkey.pem /etc/nginx/ssl

mv /tmp/fullchain.pem /etc/nginx/ssl

mv /tmp/monitor.py /opt/www/monitor/cgi-bin

chown -R www-data:www-data /opt/www

sudo systemctl enable nginx
