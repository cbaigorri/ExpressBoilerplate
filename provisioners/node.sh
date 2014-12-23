#!/usr/bin/env bash

sudo apt-get install -y libyaml-dev zlib1g-dev openssl libssl-dev g++ git

sudo mkdir /tmp
cd /tmp

if ! type "node" > /dev/null; then
  VERSION=0.10.28

  mkdir -p /tmp/node-build
  cd /tmp/node-build

  wget http://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz
  tar -xvf node-v${VERSION}.tar.gz
  cd node-v${VERSION}

  ./configure
  make
  sudo make install
  sudo ln -s /usr/local/bin/node /usr/bin/node

  cd /tmp
  rm -rf /tmp/node-build

  sudo adduser --system --no-create-home --disabled-login --disabled-password --group node
fi

# Create User
sudo adduser --system --no-create-home --disabled-login --disabled-password --group apps

# coffee-script dependency
sudo npm install coffee-script -g


echo "apps soft nofile 15000" | sudo tee -a /etc/security/limits.conf
echo "apps hard nofile 65000" | sudo tee -a /etc/security/limits.conf

echo "session required        pam_limits.so" | sudo tee -a /etc/pam.d/common-session
