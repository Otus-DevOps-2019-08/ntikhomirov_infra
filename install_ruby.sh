#!/bin/bash
sudo apt update
#Инсталяция ruby и bundler
sudo apt install -y ruby-full ruby-bundler build-essential
#Проверяем версии 
ruby -v
bundler -v
