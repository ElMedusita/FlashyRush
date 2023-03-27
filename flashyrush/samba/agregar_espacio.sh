#! /bin/bash

clear
figlet FlashyRush
echo -n "Ingrese el nombre del espacio a crear: "
read espacio
cat /etc/samba/smb.conf | grep $espacio > /dev/null
if [ $? -eq 0 ]
	then
		echo "Ya se encuentra actualmente este espacio"
		exit
fi
echo -n "Introduzca una breve descripción del espacio: "
read descripcion
echo -n "Introduzca el directorio a compartir: "
read directorio
while true
	do
		echo -n "¿Desea que los ficheros compartidos puedan ser modificados? s/n: "
		read resp
		if [ "$resp" = "s" -o "$resp" = "S" ]
			then
				editable="yes"
				break
			else
				if [ "$resp" = "n" -o "$resp" = "N" ]
					then
						editable="no"
						break
					else
						echo "Respuesta no válida"
				fi
		fi
	done
	
echo -n "Introduzca el nombre del usuario para acceder: "
read usuario

if [ $? -eq 1 ]
	then
		echo "El usuario $usuario no se encuentra. Se procederá a crear"
		echo "Creando usuario $usuario..."
		sudo useradd -g sambashare $usuario
		sudo passwd $usuario
		sudo smbpasswd -a $usuario
fi

echo "[$espacio]" > nuevo_samba.conf
echo "comment = $descripcion" >> nuevo_samba.conf
echo "path = $directorio" >> nuevo_samba.conf
echo "writeable = $editable" >> nuevo_samba.conf
echo "browseable = yes" >> nuevo_samba.conf
echo "valid users = $usuario" >> nuevo_samba.conf
echo "guest ok = no" >> nuevo_samba.conf
cat nuevo_samba.conf >> /etc/samba/smb.conf

echo "Done! Para cualquier configurarión, puede modificar el fichero /etc/samba/smb.conf"
