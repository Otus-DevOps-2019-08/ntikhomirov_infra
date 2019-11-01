#!/bin/bash
apt update -y
#Cтавим tzdata так как требует дополнительного вмешательства

apt update
export DEBIAN_FRONTEND=noninteractive
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
apt-get install tzdata
dpkg-reconfigure --frontend noninteractive tzdata
