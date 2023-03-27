#! /bin/bash
clear
figlet FlashyRush

while true
	do
		sudo nmap -sn 192.168.1.0/24 > nmap
		for ip in `cat nmap | cut -d" " -f 5 | grep 192.168.1`
			do
				nc -v -w2 $ip 8000 > datos.txt
				info=$(cat datos.txt)
				if [ -n "$info" ]
					then
						echo "¡Se han encontrado datos de $ip!"
						cat datos.txt
						if [ ! -d datos_finales ]
							then
								mkdir datos_finales
								cat datos.txt >> datos_finales/recop_datos.txt
								echo "=========================" >> datos_finales/recop_datos.txt
							else
								cat datos.txt >> datos_finales/recop_datos.txt
								echo "=========================" >> datos_finales/recop_datos.txt
						fi
				fi
			done
	done
