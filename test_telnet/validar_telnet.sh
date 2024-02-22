
# Declarando variables
ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

port=22

# Verifica que se haya proporcionado un archivo como argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <archivo_de_ips.txt>"
    exit 1
fi

# Quita primero los espacios en blanco y despues los saltos de linea vacios
#sed -i 's/ //g' $1
sed -i '/^$/d'  $1


# Lee el archivo línea por línea e imprime cada IP
while IFS="|" read -r ip port2 ; do #|| [[ -n "$ip" ]]; do
    
	#echo "$ip"
if [[  $ip =~ $ip_pattern ]]; then
#unset Result_conec
	
	echo -e "\033[0;33m  - Verificando conexión telnet con el Servidor: $ip Puerto: $port"    
	Result_conec=$(echo -e "quit" | timeout 2  telnet "$ip" $port 2>/dev/null | grep "Escape character")
    if [ -z "$Result_conec" ]; then
        echo -e "\033[0;31m -----> No se puede acceder al servidor $ip con el  puerto 22 \033[0m"
	echo $ip >> no_acceso_ip_port_$port.txt
        # Aquí podrías agregar una lógica para notificar por correo, mensaje, etc.
    else
        echo -e " \033[0;32m ----> El puerto 22 está accesible en $ip \033[0m "
	echo $ip >> si_acceso_ip_port_$port.txt
    fi

    
    
else
    echo $ip "- No es ip" >> no_ip.txt 	
fi


done <  "$1"
