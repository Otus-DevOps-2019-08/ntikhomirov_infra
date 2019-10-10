#!/bin/bash

apt install nginx -y

mv /tmp/otus.conf /etc/nginx/conf.d/

mkdir /etc/nginx/ssl

mv /tmp/privkey.pem /etc/nginx/ssl

mv /tmp/fullchain.pem /etc/nginx/ssl

sudo systemctl enable nginx
