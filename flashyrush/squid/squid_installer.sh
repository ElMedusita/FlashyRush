#! /bin/bash

clear
figlet FlashyRush
echo "Bienvenido al instalador de la herramienta Squid Proxy"
echo "Actualizando paquetes..."
sudo apt update
echo "Instalando squid"
sudo apt install squid -y
sudo ufw allow 3128

sudo cp squid.conf /etc/squid/squid.conf #Donde ya está configurado para que funcione con una lista negra
while true
	do
		echo -n "¿Desea introducir alguna web para denegarle el acceso desde los equipos? [s/n]: "
		read resp
	       if [ "$resp" = "s" -o "$resp" = "S" ]
		   then
		   	echo -n "Introduzca una dirección web: "
		   	read web
		   	echo $web >> /etc/squid/lista_negra
		   else
			echo "Proceso finalizado"
			echo "Para modificar o agregar páginas web prohibidas, ejecute 'sudo gedit /etc/squid/lista_negra' y añada un sitio web por cada línea de texto"
			echo "Puede usar cualquier otro editor a parte de gedit"
			echo "Se recomienda reiniciar el equipo"
			break
		fi
	done
echo "Reiniciando el servicio..."
sudo systemctl reload squid.service
