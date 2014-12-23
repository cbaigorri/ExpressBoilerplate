#!/usr/bin/env bash

sudo locale-gen en_CA.UTF-8

sudo ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime

sudo apt-get update -y -q > /dev/null

# Install Make and other build tools
if ! type "make" > /dev/null; then
  sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
  sudo apt-get update -y
  sudo apt-get -q -y install build-essential checkinstall
fi

# Install CURL
if ! type "curl" > /dev/null; then
  sudo apt-get -q -y install curl
fi

# Setup time syncp
sudo apt-get install ntp -y

NTP="
ntpdate ntp.ubuntu.com pool.ntp.org
"
echo "${NTP}" | sudo tee -a /etc/cron.daily/ntpdate
sudo chmod 755 /etc/cron.daily/ntpdate

CONF="
server 0.ca.pool.ntp.org
server 1.ca.pool.ntp.org
server 2.ca.pool.ntp.org
server 3.ca.pool.ntp.org
"
echo -e "${CONF}" | sudo tee -a /etc/ntp.conf
sudo chmod 755 /etc/ntp.conf

sudo service ntp restart
