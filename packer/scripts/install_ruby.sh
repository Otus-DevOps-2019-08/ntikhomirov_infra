#!/bin/bash
apt update

#Инсталяция ruby и bundler
apt install -y ruby-full ruby-bundler build-essential

#Обновляем, ругань достала в консоле
gem install bundle
