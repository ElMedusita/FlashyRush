#! /bin/bash

clear
figlet FlashyRush

echo "Bienvenido al gestor de unidades organizativas OpenLDAP"
sudo slapcat | grep "ou:" | cut -d" " -f 2 > ou.txt
sudo slapcat | grep "cn:" | cut -d" " -f 2 > cn.txt
echo "Actualmente se encuentran las siguientes unidades organizativas:"

while true
	do
		dominio=$(sudo slapcat | head -1 | cut -d" " -f 2)
		clear
		figlet OpenLDAP
		echo "Bienvenido al asistente de creación de entidades de OpenLDAP"
		echo "Elija una opción a crear:"
		echo "===================================="
		echo "1 Unidad organizativa"
		echo "2 Grupo"
		echo "3 Usuario"
		echo "q Salir"
		echo "===================================="
		read menu

		case $menu in
		1)
			echo
			echo -n "Introduzca el nombre de la nueva unidad organizativa: "
			read u_organizativa
			echo "dn: ou=$u_organizativa,$dominio" > u_organizativa.ldif
			echo "objectClass: organizationalUnit" >> u_organizativa.ldif
			echo "ou: $u_organizativa" >> u_organizativa.ldif
			echo -n "[sudo] contraseña para $USER: "
			read -s contra
			echo ""
			sudo ldapadd -x -D "cn=admin,$dominio" -f u_organizativa.ldif -w $contra
			sleep 2s
		;;
		2)
			if [ -e gid.txt ]
				then
					cat gid.txt
			fi
			echo -n "Introduzca el nombre del nuevo grupo: "
			read nuevo_grupo
			echo ""
			echo -n "Introduzca el nombre de la unidad organizativa a vincular: "
			read unidad_vincular
			echo ""
			echo -n "Escoja un número de GID para el grupo (puede ejecutar 'cat /etc/group' o 'sudo slapcat' para consultar GIDs usados): "
			read gid
			echo ""
			echo "dn: cn=$nuevo_grupo,ou=$unidad_vincular,$dominio" > grupo.ldif
			echo "objectClass: posixGroup" >> grupo.ldif
			echo "gidNumber: $gid" >> grupo.ldif
			echo "cn: $nuevo_grupo" >> grupo.ldif
			echo -n "[sudo] contraseña para $USER: "
			read -s contra
			echo ""
			sudo ldapadd -x -D "cn=admin,$dominio" -f grupo.ldif -w $contra
			echo "Grupo: $nuevo_grupo GID: $gid Unidad organizativa: $unidad_vincular" >>gid.txt
			sleep 2s
		;;
		3)
			if [ -e uid.txt ]
				then
					cat uid.txt
			fi
			echo -n "Introduzca el nombre del nuevo usuario: "
			read nuevo_usuario
			echo ""
			echo -n "Introduzca el número de UID para el nuevo usuario (puede ejecutar 'cat /etc/passwd' o 'sudo slapcat' para consultar UIDs usados): "
			read uid
			echo ""
			echo -n "Introduzca el nombre de la unidad organizativa a vincular: "
			read ou_vincular
			echo ""
			cat gid.txt | grep $ou_vincular
			echo -n "Introduzca el número de GID de un grupo a vincular: "
			read numero_gid_vincular
			echo ""
			echo -n "Introduzca el nombre completo del usuario a crear: "
			read cn
			echo ""
			echo -n "Introduzca la contraseña para el usuario: "
			read usuario_contra
			echo ""
			echo "dn: uid=$nuevo_usuario,ou=$ou_vincular,$dominio" > usuario.ldif
			echo "objectClass: posixAccount" >> usuario.ldif
			echo "objectClass: inetOrgPerson" >> usuario.ldif
			echo "objectClass: person" >> usuario.ldif
			echo "cn: $cn" >> usuario.ldif
			echo "sn: $nuevo_usuario" >> usuario.ldif
			echo "uid: $nuevo_usuario" >> usuario.ldif
			echo "uidNumber: $uid" >> usuario.ldif
			echo "gidNumber: $numero_gid_vincular" >> usuario.ldif
			echo "loginShell: /bin/bash" >> usuario.ldif
			echo "userPassword: $usuario_contra" >> usuario.ldif
			echo "homeDirectory: /home/$nuevo_usuario" >> usuario.ldif
			echo -n "[sudo] contraseña para $USER: "
			read -s contra
			echo ""
			sudo ldapadd -x -D "cn=admin,$dominio" -f usuario.ldif -w $contra
			echo "Usuario: $nuevo_usuario Grupo: $nuevo_grupo GID: $gid Unidad organizativa: $unidad_vincular" >>uid.txt
			sleep 2s
		;;
		q)
			exit
		;;
		esac
	done
