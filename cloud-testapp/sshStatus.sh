#!/bin/bash
ssh google.otus.host  <<EOF
sudo apt update -y
sudo apt install git -y

mkdir -p ~/testapp
cd ~/testapp

git clone https://github.com/Otus-DevOps-2019-08/ntikhomirov_infra.git
git checkout cloud-testapp

EOF
