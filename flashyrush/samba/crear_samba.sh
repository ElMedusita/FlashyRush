#! /bin/bash

clear
figlet FlashyRush
sudo apt install samba

echo -n "Introduzca el nombre de usuario para acceder por Samba: "
read usuario
cat /etc/passwd | grep $usuario
if [ $? -eq 1 ]
	then
		echo "Creando usuario $usuario..."
		sudo useradd -g sambashare $usuario
		sudo passwd $usuario
		sudo smbpasswd -a $usuario
	else
		echo "El usuario $usuario ya existe en el sistema"
		exit
fi
echo -n "Escriba el nombre de la carpeta a compartir: "
read carpeta
sudo mkdir /$carpeta
sudo chown $usuario:sambashare /$carpeta/
sudo chmod 777 /$carpeta

echo -n "Escriba el nombre del dominio: "
read dominio
echo "[global]" > /etc/samba/smb.conf
echo "   workgroup = $dominio" >> /etc/samba/smb.conf
echo "   netbios name = $(cat /etc/hostname)" >> /etc/samba/smb.conf
cat smb.conf >> /etc/samba/smb.conf
#smb.conf contiene las directivas base de una instalación limpia, no tiene más
echo "Espacio Samba creado correctamente"
echo "Habilitando cortafuegos..."
sudo ufw enable
sudo ufw allow 445
echo "Done! Para cualquier configurarión, puede modificar el fichero /etc/samba/smb.conf"

