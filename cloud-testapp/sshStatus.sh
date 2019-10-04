#!/bin/bash
ssh google.otus.host  <<EOF
sudo apt update -y
sudo apt install git -y

mkdir -p ~/testapp
cd ~/testapp

git clone https://github.com/Otus-DevOps-2019-08/ntikhomirov_infra.git
cd ~/testapp/ntikhomirov_infra/
git checkout cloud-testapp


chmod +x ./install_ruby.sh
chmod +x ./install_mongodb.sh
chmod +x ./deploy.#!/bin/sh

./install_ruby.sh
./install_mongodb.sh
./deploy.sh

EOF
