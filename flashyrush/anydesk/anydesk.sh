#! /bin/bash

echo "Actualizando paquetes..."
sudo apt update
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk.list
	
sudo apt update

echo "Instalando AnyDesk..."
sudo apt install anydesk
