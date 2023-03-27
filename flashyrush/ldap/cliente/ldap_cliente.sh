#! /bin/bash

clear
figlet FlashyRush

echo "Actualizando paquetes..."
sudo apt update
echo "Instalando OpenLDAP..."
sudo apt install libnss-ldap libpam-ldap ldap-utils
sudo cp nsswitch.conf /etc/nsswitch.conf
