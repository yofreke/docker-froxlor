#!/bin/bash
echo "Restarting mysql"
service mysql restart


if [ "$RUN_SETUP" == "1" ]; then
  echo "Setting up mysql"
  mysql_install_db
  mysql_secure_installation
  echo "Installing froxlor"
  apt-get update -y
  apt-get install froxlor php5-curl -y
  echo ""
  echo ">> Will now exit"
  sleep 8
  exit 0
fi


echo "Restarting apache2"
service apache2 restart


bash