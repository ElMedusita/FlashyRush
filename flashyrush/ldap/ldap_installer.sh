#! /bin/bash

clear
figlet FlashyRush

echo "Bienvenido a la instalación de LDAP"
sudo ufw enable
sudo ufw allow 389
sudo apt update
sudo apt install slapd ldap-utils
sudo dpkg-reconfigure slapd
echo "Done! LDAP instalado correctamente en el sistema"

