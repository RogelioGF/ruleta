#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Función para manejar la señal Ctrl+C
# Esta función restaura el cursor y sale del script de manera segura
ctrl_c() {
    echo -e "\n\n${redColour}[!] Saliendo... ${endColour}\n"
    tput cnorm && exit 1
}

# Captura de la señal Ctrl+C
trap ctrl_c INT

# Panel de ayuda para el usuario
# Explica cómo usar el script y las opciones disponibles
helpPanel(){
    echo -e "\n${blueColour}Ayuda:${endColour} Utiliza este script como sigue:\n"
    echo -e "\t${blueColour}-m <dinero>${endColour} ${grayColour}: Especifica la cantidad de dinero que deseas para jugar.${endColour}\n"
    echo -e "\t${blueColour}-t <técnica>${endColour} ${grayColour}: Técnica a utilizar.${endColour}${purpleColour}(martingala/inverseLabrouchere)${endColour}\n"
    exit 1
}

# Implementación de la técnica Martingala
# Se aumenta la apuesta después de cada pérdida hasta que se gane
martingala(){
    # Muestra el dinero actual del jugador
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual ${endColour}${yellowColour}$money€${endColour}"
    # Solicita al usuario cuánto dinero quiere apostar inicialmente
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -->${endColour} " && read initial_bet
    # Solicita al usuario si desea apostar a par o impar 
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? --> ${endColour}" && read par_impar
    # Informa al usuario sobre la cantidad de dinero y el tipo de apuesta que va a realizar
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inical de${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} a${endColour} ${yellowColour}$par_impar${endColour}"
    
    backup_bet=$initial_bet # Guarda la apuesta inicial para restaurarla después de una victoria
    COUNTER=0               # Contador de jugadas
    jugadas_malas=""        # Variable para almacenar las jugadas malas consecutivas
    max_money=0             # Almacena el dinero máximo alcanzado durante el juego

    tput civis # Ocultar el cursor en la terminal
    while true; do
    
    # Deduce la apuesta inicial del dinero disponible
    money=$(($money - $initial_bet))

    # Generar número aleatorio para simular el resultado de la ruleta
    randon_numer="$(shuf -i 0-36 -n1)"
    let COUNTER++ # Incrementa el contador de jugadas
    
        if [ ! "$money" -lt 0 ]; then  # Si el dinero disponible es mayor que cero
            if [ "$par_impar" == "par" ]; then # Si la apuesta es a par
                if [ "$(($randon_numer % 2))" -eq 0  ]; then # Si el número es par
                    if [ "$randon_numer" -eq 0 ]; then # Si el número es 0, pierdes y la apuesta se duplica
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas+="$randon_numer " #Almacena el valor del numero aleatorio que salio impar
                    else  # Si el número es par y no es 0, ganas    
                        reward=$(($initial_bet*2))  # Calcula la recompensa
                        money=$(($money+$reward))   # Añade la recompensa al dinero disponible
                        initial_bet=$backup_bet     # Restaura la apuesta inicial
                        jugadas_malas=""            # Resetea la secuencia de jugadas malas
                        max_money=$money            # Actualiza el dinero máximo alcanzado
                    fi
                else # Si es un numero impar, la apuesta se duplica
                    initial_bet=$(($initial_bet*2))
                    jugadas_malas+="$randon_numer "
                fi
            else # Si apostamos al numero impar
                if [ "$(($randon_numer % 2))" -eq 1  ]; then # Si el número es impar, ganas
                    reward=$(($initial_bet*2))
                    money=$(($money+$reward))
                    initial_bet=$backup_bet
                    jugadas_malas=""
                    max_money=$money                
                else # Si el número es par, la apuesta se duplica
                    initial_bet=$(($initial_bet*2))
                    jugadas_malas+="$randon_numer "
                fi
            fi
        else # Si el dinero disponible es menor o igual a cero (te quedas sin dinero)
            echo -e "\n${yellowColour}[!]${endColour}${redColour} No tienes mas pasta cabrón!${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has jugado un total de${blueColour} "$(($COUNTER-1))" ${endColour}${grayColour}jugadas${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has alcanzado un total de${endColour}${yellowColour} $max_money€${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las jugadas malas consecutivas que han salido: ${endColour}\n"
            echo -e "${yellowColour}[ ${jugadas_malas}]${endColour}" # Muestra la secuencia de jugadas malas
            tput cnorm; exit 0 # Restaura el cursor y sale del script
        fi        
    done
    tput cnorm # Restaura el cursor al finalizar
}


inverseLabrouchere(){
    # Muestra el dinero actual del jugador
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual ${endColour}${yellowColour}$money€${endColour}"
    # Solicita al usuario si desea apostar a par o impar
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? --> ${endColour}" && read par_impar
    
    initial_money=$money                # Guarda el dinero inicial
    declare -a my_sequence=(1 2 3 4)    # Secuencia inicial de apuestas
    
    # Muestra la secuencia inicial de apuestas
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

    bet=$((${my_sequence[0]} + ${my_sequence[-1]})) # Calcula la apuesta inicial sumando el primer y último número de la secuencia
    my_sequence=(${my_sequence[@]})                 # Actualiza la secuencia de apuestas
    COUNTER=0                                       # Contador de juagadas
    
    # Establece los límites para renovar la secuencia
    bet_to_renew=$(($money + 50))       # Límite superior para renovar la secuencia
    bet_to_reset_lower=$(($money - 50)) # Límite inferior para renovar la secuencia
    
    jugadas_malas=()    # Inicializa el array para almacenar las jugadas malas consecutivas
    my_secuence_max=()  # Inicializa el array para almacenar la secuencia máxima de jugadas malas
    max_money=$money    # Inicializamos max_money con el dinero inicial

    tput civis # Oculta el cursor
        while true; do
        randon_numer="$(shuf -i 0-36 -n1)"  # Genera un número aleatorio entre 0 y 36 para simular la ruleta
        let money-=$bet # Resta la apuesta del dinero disponible
        let COUNTER++   # Incrementa el contador de jugadas
        if [ ! "$money" -lt 0 ]; then  # Si el dinero no es menor que cero
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour} ${yellowColour}$bet€${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour} ${yellowColour}$money€${endColour}"

            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $randon_numer${endColour}"
                
            if [ "$par_impar" == "par" ]; then                  # Si el jugador apostó a número par
                if [ "$(($randon_numer % 2))" -eq 0  ]; then    # Si el número es par
                    if [ "$randon_numer" -eq 0 ]; then          # Si el número es cero, pierdes
                        
                        jugadas_malas+=("$randon_numer") # Almacena la jugada mala en el array
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el${endColour} ${blueColour}0${endColour}${grayColour}, por tanto ${endColour}${redColour}¡pierdes!${endColour}"
                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]})) # Calcula la nueva apuesta                      
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]} # Si queda un solo número en la secuencia, apuesta ese valor
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4) # Restablece la secuencia inicial
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                        fi

                    else # El número es par, ganas.

                        if [ ${#jugadas_malas[@]} -gt ${#my_secuence_max[@]} ]; then
                            my_secuence_max=("${jugadas_malas[@]}") # Actualiza la secuencia máxima de jugadas malas
                        fi
                        jugadas_malas=()        # Resetea el array de jugadas malas
                        
                        echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es par,${endColour} ${greenColour}¡ganas!${endColour}"
                        my_sequence+=($bet)     # Añade la apuesta ganadora a la secuencia
                        reward=$(($bet*2))
                        let money+=($reward)    # Actualiza el dinero disponible con las ganancias
                         
                        if [ $money -gt $max_money ]; then
                            max_money=$money
                        fi
            
                        # Verifica si se ha alcanzado el límite superior o inferior para renovar la secuencia
                        if [ $money -gt $bet_to_renew ] || [ $money -lt $bet_to_reset_lower ]; then
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour} ${yellowColour}$bet_to_renew€${endColour}${grayColour} o ha bajado por debajo de${endColour} ${yellowColour}$bet_to_reset_lower€${endColour}"
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Se renueva la secuencia inicial a [1 2 3 4]${endColour}"
                            bet_to_renew=$(($money + 50))
                            bet_to_reset_lower=$(($money - 50))
                            my_sequence=(1 2 3 4)
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        fi

                        echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]})) # Calcula la próxima apuesta

                    fi
                else # apostando a par, sale impar, pierdes...

                    jugadas_malas+=("$randon_numer")  # Almacena la jugada mala en el array
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido impar.${endColour} ${redColour}¡pierdes!${endColour}"
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null
                    my_sequence=(${my_sequence[@]})

                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    fi

                fi
                
            else # Condicional cuando apostamos a numero impar
                if [ "$(($randon_numer % 2))" -eq 1  ]; then # Si el numero aleatorio es un numero impar, ganas

                    if [ ${#jugadas_malas[@]} -gt ${#my_secuence_max[@]} ]; then
                        my_secuence_max=("${jugadas_malas[@]}")  # Actualiza la secuencia máxima de jugadas malas
                    fi
                    jugadas_malas=()        # Resetea el array de jugadas malas
                    
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es impar,${endColour} ${greenColour}¡ganas!${endColour}"
                    my_sequence+=($bet)     # Añade la apuesta ganadora a la secuencia
                    reward=$(($bet*2))
                    let money+=($reward)    # Actualiza el dinero disponible con las ganancias

                    # Después de cada cambio en el dinero, actualiza max_money si es necesario
                    if [ $money -gt $max_money ]; then
                        max_money=$money    # Actualiza el dinero máximo alcanzado
                    fi

                    # Verifica si se ha alcanzado el límite superior o inferior para renovar la secuencia
                    if [ $money -gt $bet_to_renew ] || [ $money -lt $bet_to_reset_lower ]; then
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour} ${yellowColour}$bet_to_renew€${endColour}${grayColour} o ha bajado por debajo de${endColour} ${yellowColour}$bet_to_reset_lower€${endColour}"
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Se renueva la secuencia inicial a [1 2 3 4]${endColour}"
                        bet_to_renew=$(($money + 50))
                        bet_to_reset_lower=$(($money - 50))
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    fi

                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

                else # Si el número no es impar, pierdes
                    jugadas_malas+=("$randon_numer")  # Almacena la jugada mala en el array                  
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido par.${endColour} ${redColour}¡pierdes!${endColour}"
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null
                    my_sequence=(${my_sequence[@]})
                    
                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    fi

                fi    

            fi    

        else # si nos quedamos sin dinero

            echo -e "\n${yellowColour}[!]${endColour}${redColour} No tienes mas pasta cabrón!${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Has jugado un total de${blueColour} "$(($COUNTER-1))" ${endColour}${grayColour}jugadas${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero máximo alcanzado:${endColour}${yellowColour} $max_money€${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia de numeros aleatorios máxima de jugadas malas consecutivas es:${endColour}${greenColour} ${my_secuence_max[@]}${endColour}"
            tput cnorm; exit 0  # Restaura el cursor y sale del script

        fi    

        done

    tput cnorm # Restaura el cursor al finalizar

}

# Procesa las opciones y parámetros pasados al script
while getopts "m:t:h" arg; do
    case $arg in
    m) money=$OPTARG;;      # Opción -m: establece la cantidad de dinero inicial
    t) technique=$OPTARG;;  # Opción -t: establece la técnica de apuesta (martingala o inverseLabrouchere)
    h) helpPanel;;          # Opción -h: muestra el panel de ayuda
    esac
done

# Verifica que tanto el dinero como la técnica hayan sido especificados
if [ $money ] && [ $technique ]; then
    # Verifica si la técnica seleccionada es "martingala"
    if [ "$technique" == "martingala" ]; then
        martingala # Llama a la función martingala
    elif [ "$technique" == "inverselabrouchere" ]; then
        inverseLabrouchere  # Llama a la función inverseLabrouchere
    else
        echo -e "\n${redColour}La técnica introducida no existe${endColour}" # Muestra un mensaje de error si la técnica no es válida
    fi
else
    helpPanel # Si falta dinero o técnica, muestra el panel de ayuda
fi
