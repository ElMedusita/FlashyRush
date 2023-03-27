#! /bin/bash

clear
figlet FlashyRush

echo "Este es el asistente para agregar un nuevo equipo al servidor DNS"
dominio=$(ls /etc/bind | grep ".com" | cut -d"." -f 2,3 | tail -1)
echo "Se ha encontrado el siguiente doninio: $dominio"

while true
	do
		echo -n "Por favor, introduzca la dirección IP del equipo que desea agregar: "
		read ip
		echo -n "Por favor, introduzca el nombre que desea asignar a la relación con $ip: "
		read nombre

		echo "$nombre 	IN	A	$ip" >> /etc/bind/db.$dominio
		ip_recortada=$(echo $ip | cut -d"." -f 4)
		echo "$ip_recortada	IN	PTR	$nombre.$dominio." >> /etc/bind/db.$dominio.inverso
		sudo systemctl reload bind9.service > /dev/null
		echo -n "¿Desea agregar otro equipo? s/n "
		read exec
		if [ "$exec" = "s" -o "$exec" = "S" ]
			then
				continue
			else
				if [ "$exec" = "n" -o "$exec" = "N" ]
					then
						exit
					else
						echo "Respuesta no válida"
				fi
		fi
	done
echo "Done! Para mayor configuración, modificar en /etc/bind/db.$dominio y /etc/bind/db.$dominio.inverso"
