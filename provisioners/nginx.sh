#!/usr/bin/env bash

NGX_HOME=/etc/nginx

# Update and install
sudo apt-get -y -q update
sudo apt-get -q -y install nginx

# Copy configuration file
sudo cp /resources/nginx/mime.types ${NGX_HOME}/mime.types
sudo cp /resources/nginx/nginx.conf ${NGX_HOME}/nginx.conf

# Create sites folder
sudo mkdir -p ${NGX_HOME}/sites-available
sudo mkdir -p ${NGX_HOME}/sites-enabled
sudo rm -rf ${NGX_HOME}/sites-available/default
sudo cp /resources/nginx/no-default ${NGX_HOME}/sites-available/no-default
if ! [ -a "${NGX_HOME}/sites-enabled/no-default" ]; then
  sudo ln -s ${NGX_HOME}/sites-available/no-default ${NGX_HOME}/sites-enabled/no-default
fi

# Copy SSL certificates
# if ! [ -d "/ssl-certs" ]; then
#   sudo mkdir /ssl-certs
# fi
# sudo cp /resources/ssl-certs/* /ssl-certs
# sudo chmod 600 /ssl-certs/*.key

sudo useradd --no-create-home nginx

# start up the server
sudo service nginx start

# start on restart
sudo update-rc.d nginx defaults
