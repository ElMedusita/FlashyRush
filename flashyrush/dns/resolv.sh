#!/bin/bash

#Cambiar a la dirección IP actual en /etc/resolv.conf
while true
	do
		ip=$(hostname -I)
		echo "nameserver $ip" > /etc/resolv.conf
		sleep 10s
	done
