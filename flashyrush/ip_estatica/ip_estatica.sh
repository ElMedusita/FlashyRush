#! /bin/bash

clear
figlet FlashyRush
red=$(ip a | grep "2: " | cut -d" " -f 2)
gateway=$(echo $ip | cut -d"." -f 1-3)
echo -n "Introduzca una IP válida para establecer como estática en la red. Es necesario conectarse por cable [Ejemplo: 192.168.1.100]: "
read ip
gateway=$(echo $ip | cut -d"." -f 1-3)
echo "# Let NetworkManager manage all devices on this system" > 01-network-manager-all.yaml
echo "network:" >> 01-network-manager-all.yaml
echo "  version: 2" >> 01-network-manager-all.yaml
echo "#  renderer: NetworkManager" >> 01-network-manager-all.yaml
echo "  renderer: networkd" >> 01-network-manager-all.yaml
echo "  ethernets:" >> 01-network-manager-all.yaml
echo "    $red" >> 01-network-manager-all.yaml
echo "      dhcp4: no" >> 01-network-manager-all.yaml
echo "      addresses: [$ip/24]" >> 01-network-manager-all.yaml
echo "      gateway4: $gateway.1" >> 01-network-manager-all.yaml
echo "      nameservers:" >> 01-network-manager-all.yaml
echo "        addresses: [8.8.8.8,8.8.4.4]" >> 01-network-manager-all.yaml
sudo cp 01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
sudo netplan apply

#Preparar el fichero que se ejecutará en cliente para establecer un servidor proxy fijo. Aprovecho que ya tengo la IP

echo "#! /bin/bash" > ../squid/establecer_proxy.sh
echo "" >> ../squid/establecer_proxy.sh
echo "clear" >> ../squid/establecer_proxy.sh
echo "figlet FlashyRush" >> ../squid/establecer_proxy.sh
echo 'echo "Estableciendo proxy..."' >> ../squid/establecer_proxy.sh
echo 'echo "export http_proxy=http://'$ip':3128/" >> /etc/profile' >> ../squid/establecer_proxy.sh
echo 'echo "export https_proxy=http://'$ip':3128/" >> /etc/profile' >> ../squid/establecer_proxy.sh
echo 'echo "Se recomienda reiniciar el equipo"' >> ../squid/establecer_proxy.sh

echo "Done! IP estática: $ip"

