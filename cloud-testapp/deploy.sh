#!/bin/bash
#Деплой приложения
mkdir -p ~/app
cd ~/app
git clone -b monolith https://github.com/express42/reddit.git
cd ~/app/reddit
bundle install
puma -d
