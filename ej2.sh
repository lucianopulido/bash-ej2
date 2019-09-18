#!/bin/bash

#---------------------------------------Inicio Encabezado---------------------------------------------------------##
# Nombre Script: "ej2.sh"
# Numero Trabajo Practico: 1
# Numero Ejercicio: 2
# Tipo: 1º Entrega
# Integrantes: 
#		Nombre y Apellido			DNI
#
#		Agustin Barrientos			40306406
#		Lautaro Marino				39457789
#		Nicolas Pompeo				37276705
#		Luciano Pulido				40137604
#		Daniel Varela				40388978
#
##--------------------------------------Fin del Encabezado--------------------------------------------------------##

mostrar_ayuda() {
    echo "Descripcion"
    echo "El script cambia los nombres de los archivos que posean uno o mas espacios en sus nombres. Colocando el caracter _"
    echo "Forma de invocar el script:"
    echo "./ej2.sh [opcion] [ruta o directorio]"
    echo "La opcion puede ser una de las siguientes: -r (el script se aplica de forma recursiva en subdirectorios)"
    echo "                                           -h,-? o -help (el script muestra su descripcion y los parametros que recibe (esta ayuda)"
    echo "La otra forma de invocarlo es solo llamarlo de la siguiente manera:"
    echo "./ej2.sh -h, -? o -help"
    echo "En este ultimo caso solo le mostrara esta ayuda"
    echo "Tambien puede llamar al script asi: ./ej2 -r"
    echo "En este ultimo caso, se aplicara la recursividad en subdirectorios sobre la ruta actual"
    echo "En caso de no colocar nada en la opcion, pero si en la ruta o directorio, no se aplicara la recursividad, en el directorio indicado"
    exit 0
}

if [[ $# -eq 0 ]]
then
	echo "Error, no se coloco ningun parametro"
	exit 1
fi

directorio=`pwd`

if test $# -eq 1; then
    
	if test $1 = "-h" || test $1 = "-?" || test $1 = "-help"; then
        mostrar_ayuda
	exit 0

    elif test $1 = "-r"; then
        echo "Se tomo como ruta el directorio actual"
        cd "$directorio"
        archivos=` find "$directorio" -type f -name '* *'` #guardo la cadena que retorna, y la utilizo como array
        ifs_prev="$IFS"
        IFS="$(echo -e "\n\r")"  #indico el separador de elementos del array
        for file in ${archivos[*]} # recorro array
        do
           if [[ -f "$file" ]]
           then						#si es un archivo guardo su nombre mejorado en una variable
	      IFS="$ifs_prev"
	      var="$(echo $file | tr ' ' '_')"
	      if [[ -f "$var" ]]
	      then
	      var="$var-1"			#si el nombre existe le agrega un sufijo -1
	      fi		
              mv "$file" "$var"			#cambio el nombre del archivo
              ((contadorMod++))
           fi
        done

       echo
       echo "Cantidad de Archivos modificados: $contadorMod "
       exit 0

    elif test -d $1; then
        if [[ "$1" == .* ]]
        then
            nuedir=$1
	    nuedir=${nuedir#\.}
	    directorio="$directorio$nuedir"	#si ingreso directorio me fijo si es relativa o absoluta
        else				
            directorio=$1
        fi

    cd "$directorio"
        
    fi
fi

contadorMod=0

if test $# -eq 2; then

    if ! [[ -d "$2" && "$1" == "-r" ]]
    then
        echo "directorio/parametro no valido"
        exit 1
    fi

    if [[ "$2" == .* ]]
        then
            nuedir=$2
	    nuedir=${nuedir#\.}
	    directorio="$directorio$nuedir"	#si ingreso directorio me fijo si es relativa o absoluta
        else				
            directorio=$2
        fi

    cd "$directorio" 

    archivos=` find "$directorio" -type f -name '* *'` #guardo la cadena que retorna, y la utilizo como array
    ifs_prev="$IFS"
    IFS="$(echo -e "\n\r")"  #indico el separador de elementos del array
    for file in ${archivos[*]} # recorro array
    do
        if [[ -f "$file" ]]
        then
	    IFS="$ifs_prev"
	    var="$(echo $file | tr ' ' '_')"
	    if [[ -f "$var" ]]
	    then
	    var="$var-1"
	    fi
            mv "$file" "$var"
            ((contadorMod++))
        fi
    done

    echo "Cantidad de Archivos modificados: $contadorMod "
    exit 0
fi

for f in *
do
    if [[ "$f" =~ " " && -f "$f" ]] #Identifico espacio, y recien ahi modifico..
    then
	    var="$(echo $f | tr ' ' '_')"
	    if [[ -f "$var" ]]
	    then
	    var="$var-1"
	    fi
            mv "$f" "$var"
        ((contadorMod++))
    fi
done

echo "Cantidad de Archivos modificados: $contadorMod "

exit 0
