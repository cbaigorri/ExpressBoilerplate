#!/usr/bin/env bash

NGX_HOME=/etc/nginx

for DOMAIN in "$@"
do

  CONFIG_PATH="/resources/app/nginx.conf"
  DOMAIN_CONFIG="include $CONFIG_PATH;"

  if [ -a $CONFIG_PATH ]; then

    if [ -a "${NGX_HOME}/sites-available/${DOMAIN}" ]; then
      sudo rm ${NGX_HOME}/sites-available/${DOMAIN}
    fi
    sudo echo -e "$DOMAIN_CONFIG" >> ${NGX_HOME}/sites-available/${DOMAIN}

    if ! [ -a "${NGX_HOME}/sites-enabled/${DOMAIN}" ]; then
      sudo ln -s ${NGX_HOME}/sites-available/${DOMAIN} ${NGX_HOME}/sites-enabled/${DOMAIN}
    fi

  fi

  cd /home/apps/${DOMAIN}/current/
  npm install
done

sudo service nginx restart
