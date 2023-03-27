#! /bin/bash

clear
figlet FlashyRush

echo "Actualizando paquetes..."
sudo apt update
echo "Instalando la herramienta DNS..."
sudo apt install bind9
#Crear el fichero /etc/systemd/system/resolv.service para crear el servicio resolv.conf
echo "[Unit]" > resolv.service
echo "Description = Configure /etc/resolv.conf" >> resolv.service
echo ""
echo "[Service]" >> resolv.service
echo "ExecStart=/flashyrush/dns/resolv.sh" >> resolv.service
echo ""
echo "[Install]" >> resolv.service
echo "WantedBy=multi-user.target" >> resolv.service

sudo mv  resolv.service /etc/systemd/system
sudo systemctl enable resolv.service

#Crear dominio
echo -n "Introduzca el nombre del dominio, por favor [Ejemplo: dominio.com]: "
read dominio

echo 'zone "'$dominio'"{' > named.conf.local
echo "	type master;" >> named.conf.local
echo '	file "/etc/bind/db.'$dominio'";' >> named.conf.local
echo '};' >> named.conf.local
echo '' >> named.conf.local
echo 'zone "1.168.192.in-addr.arpa"{' >> named.conf.local
echo "	type master;" >> named.conf.local
echo '	file "/etc/bind/db.'$dominio'.inverso";' >> named.conf.local
echo '};' >> named.conf.local

sudo mv named.conf.local /etc/bind/named.conf.local

echo "Dominio $dominio creado con éxito"

#Crear fichero de la zona directa

echo ";" > db.$dominio
echo "; BIND data file for local loopback interface" >> db.$dominio
echo ";" >> db.$dominio
echo '$TTL	604800' >> db.$dominio
echo "@	IN	SOA	$dominio. root.$dominio. (" >> db.$dominio
echo "			      2		; Serial" >> db.$dominio
echo "			 604800		; Refresh" >> db.$dominio
echo "			  86400		; Retry" >> db.$dominio
echo "			2419200		; Expire" >> db.$dominio
echo "			 604800 )	; Negative Cache TTL" >> db.$dominio
echo ";" >> db.$dominio
echo "@	IN	NS	$dominio." >> db.$dominio
echo "@	IN	A	127.0.0.1" >> db.$dominio
echo "@	IN	AAAA	::1" >> db.$dominio

ip=$(hostname -I)
echo "@	IN	A	$ip" >> db.$dominio
sudo mv db.$dominio /etc/bind/db.$dominio

#Crear fichero de la zona inversa

echo ";" > db.$dominio.inverso
echo "; BIND reverse data file for local loopback interface" >> db.$dominio.inverso
echo ";" >> db.$dominio.inverso
echo '$TTL	604800' >> db.$dominio.inverso
echo "@	IN	SOA	$dominio. root.$dominio. (" >> db.$dominio.inverso
echo "			      1		; Serial" >> db.$dominio.inverso
echo "			 604800		; Refresh" >> db.$dominio.inverso
echo "			  86400		; Retry" >> db.$dominio.inverso
echo "			2419200		; Expire" >> db.$dominio.inverso
echo "			 604800 )	; Negative Cache TTL" >> db.$dominio.inverso
echo ";" >> $dominio.inverso
echo "@	IN	NS	$dominio." >> db.$dominio.inverso
echo "1.0.0	IN	PTR	$dominio." >> db.$dominio.inverso

ip_reducida=$(echo $ip | cut -d"." -f 4)
echo "$ip_reducida	IN	PTR	$dominio." >> db.$dominio.inverso
sudo mv db.$dominio.inverso /etc/bind/db.$dominio.inverso

sudo systemctl reload bind9.service





