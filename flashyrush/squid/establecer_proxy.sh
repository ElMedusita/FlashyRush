#! /bin/bash

clear
figlet FlashyRush
echo "Estableciendo proxy..."
echo "export http_proxy=http://192.168.1.114:3128/" >> /etc/profile
echo "export https_proxy=http://192.168.1.114:3128/" >> /etc/profile
echo "Se recomienda reiniciar el equipo"
