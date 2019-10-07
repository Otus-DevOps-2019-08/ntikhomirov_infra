#!/bin/bash
sudo apt update -y
#Cтавим tzdata так как требует дополнительного вмешательства
sudo bash -s <<EOF
apt update
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
apt-get install tzdata
dpkg-reconfigure --frontend noninteractive tzdata
EOF

sudo apt install git -y

mkdir -p ~/testapp
cd ~/testapp

git clone https://github.com/Otus-DevOps-2019-08/ntikhomirov_infra.git
cd ~/testapp/ntikhomirov_infra/
git checkout cloud-testapp


chmod +x ./install_ruby.sh
chmod +x ./install_mongodb.sh
chmod +x ./deploy.sh

./install_ruby.sh
./install_mongodb.sh
./deploy.sh


#Устанавливаем nginx (не гоже приложению болтаться на 9292 порту)/Перенс из deploy.sh
sudo bash -s <<EOF
apt install nginx -y
EOF

#Ужасный способа не придумал как добавить конфиг для nginx
sudo bash -s <<EOF
echo 'server {' > /etc/nginx/conf.d/otus.conf
echo 'listen 10.164.0.2:80;' >> /etc/nginx/conf.d/otus.conf
echo 'server_name otus.nt33.ru 34.90.19.140;' >> /etc/nginx/conf.d/otus.conf
echo 'location / {'  >> /etc/nginx/conf.d/otus.conf
echo '    proxy_pass http://127.0.0.1:9292/;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header Host \$host;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header X-Real-IP  \$remote_addr;' >> /etc/nginx/conf.d/otus.conf
echo '    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' >> /etc/nginx/conf.d/otus.conf
echo '    allow all;' >> /etc/nginx/conf.d/otus.conf
echo '  }' >> /etc/nginx/conf.d/otus.conf
echo '}' >> /etc/nginx/conf.d/otus.conf
EOF
sudo systemctl restart nginx
sudo systemctl enable nginx
